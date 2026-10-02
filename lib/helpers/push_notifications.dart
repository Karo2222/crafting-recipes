import 'dart:async';
import 'dart:convert';

import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _notificationChannelId = 'chat_and_invitations';
const _notificationChannelName = 'Chat and invitations';
const _notificationChannelDescription =
    'Messages, friend requests, and shared-list invitations.';
const _conversationStoragePrefix = 'push_conversation_';
const _notificationStorageVersionKey = 'push_notification_storage_version';
const _notificationStorageVersion = 2;
const _maximumStoredMessages = 8;

class _StoredNotificationMessage {
  const _StoredNotificationMessage({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  final String id;
  final String text;
  final DateTime timestamp;

  Map<String, String> toJson() => {
        'id': id,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  static _StoredNotificationMessage? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id']?.toString();
    final text = value['text']?.toString();
    final timestamp = DateTime.tryParse(
      value['timestamp']?.toString() ?? '',
    );
    if (id == null || text == null || timestamp == null) return null;
    return _StoredNotificationMessage(
      id: id,
      text: text,
      timestamp: timestamp,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await PushNotifications.showBackgroundNotification(message);
}

enum PushNavigationType {
  chat,
  friendRequests,
  sharedInvitations,
}

class PushNavigationTarget {
  const PushNavigationTarget({
    required this.type,
    this.actorAccountId,
    this.entityId,
  });

  final PushNavigationType type;
  final int? actorAccountId;
  final int? entityId;
}

class PushNotifications {
  static final ValueNotifier<PushNavigationTarget?> navigationTarget =
      ValueNotifier(null);

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static int? activeChatAccountId;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> initializeAndroid() async {
    if (!_isAndroid || _initialized) return;
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notification'),
    );
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        unawaited(_clearAllNotifications());
        _handlePayload(response.payload);
      },
    );
    await _migrateStoredNotifications();
    await _createNotificationChannel();

    FirebaseMessaging.onMessage.listen(
      _showAndroidNotification,
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedRemoteMessage,
    );
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        final accountId = currentAccount;
        if (accountId == null) return;
        await _registerToken(accountId, token);
      },
      onError: (Object error, StackTrace stackTrace) {
        logger.w(
          'Push-token refresh failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    final localLaunch =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (localLaunch?.didNotificationLaunchApp == true) {
      await _clearAllNotifications();
      _handlePayload(localLaunch?.notificationResponse?.payload);
    }
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await _clearAllNotifications();
      _handleRemoteMessage(initialMessage);
    }
    _initialized = true;
  }

  static Future<void> showBackgroundNotification(
    RemoteMessage message,
  ) async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notification'),
    );
    await _localNotifications.initialize(initializationSettings);
    await _migrateStoredNotifications();
    await _createNotificationChannel();
    await _showAndroidNotification(message);
  }

  static Future<void> startForAccount(int accountId) async {
    if (!_isAndroid) return;
    await initializeAndroid();
    try {
      final permission = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        logger.i('Android notification permission was declined');
        return;
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        logger.w('Firebase did not return an Android push token');
        return;
      }
      await _registerToken(accountId, token);
    } catch (error, stackTrace) {
      logger.w(
        'Android push registration will retry on the next app start',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> stopForAccount(int? accountId) async {
    if (!_isAndroid || !_initialized) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (accountId != null && token != null && token.isNotEmpty) {
        await supabase.rpc(
          'unregister_push_device',
          params: {'p_token': token},
        );
      }
    } catch (error, stackTrace) {
      logger.w(
        'Could not unregister the Android push token remotely',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (error, stackTrace) {
      logger.w(
        'Could not invalidate the Android push token',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void consumeNavigationTarget(PushNavigationTarget target) {
    if (identical(navigationTarget.value, target)) {
      navigationTarget.value = null;
    }
  }

  static Future<void> _registerToken(int accountId, String token) async {
    final deviceId = await DeviceInfo.getDeviceId();
    await supabase.rpc(
      'register_push_device',
      params: {
        'p_token': token,
        'p_device_id': deviceId,
        'p_platform': 'android',
      },
    );
    logger.i('Android push notifications registered for account $accountId');
  }

  static Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _notificationChannelId,
      _notificationChannelName,
      description: _notificationChannelDescription,
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _showAndroidNotification(
    RemoteMessage message,
  ) async {
    final data = message.data;
    final type = data['type']?.toString();
    final title = data['title']?.toString() ?? message.notification?.title;
    final body = data['body']?.toString() ?? message.notification?.body;
    if (title == null || title.isEmpty || body == null || body.isEmpty) {
      return;
    }

    final actorAccountId =
        int.tryParse(data['actor_account_id']?.toString() ?? '');
    final actorKey = actorAccountId?.toString() ?? 'unknown';
    final actorName = data['actor_name']?.toString().trim().isNotEmpty == true
        ? data['actor_name'].toString().trim()
        : title;
    final payload = jsonEncode(data);
    final remoteNotificationId = data['notification_id']?.toString() ??
        message.messageId ??
        DateTime.now().microsecondsSinceEpoch.toString();
    if (type != 'chat_message') {
      await _showStandaloneNotification(
        type: type,
        notificationId: remoteNotificationId,
        title: title,
        body: body,
        payload: payload,
      );
      return;
    }
    if (actorAccountId != null && actorAccountId == activeChatAccountId) {
      await clearChatNotificationsForAccount(actorAccountId);
      return;
    }

    final sentAt = DateTime.tryParse(data['sent_at']?.toString() ?? '') ??
        DateTime.now().toUtc();
    final messages = await _storeConversationMessage(
      actorKey: actorKey,
      notificationId: remoteNotificationId,
      text: body,
      sentAt: sentAt,
    );
    final sender = Person(
      key: 'account_$actorKey',
      name: actorName,
      icon: await _loadActorIcon(data['actor_profile_image']?.toString()),
      important: true,
    );
    final messagingStyle = MessagingStyleInformation(
      const Person(key: 'current_account', name: 'You'),
      conversationTitle: actorName,
      groupConversation: false,
      messages: messages
          .map(
            (storedMessage) => Message(
              storedMessage.text,
              storedMessage.timestamp,
              sender,
            ),
          )
          .toList(growable: false),
    );

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _notificationChannelId,
        _notificationChannelName,
        channelDescription: _notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        category: AndroidNotificationCategory.message,
        styleInformation: messagingStyle,
        number: messages.length,
        tag: 'conversation_$actorKey',
      ),
    );
    await _localNotifications.show(
      _stableNotificationId('conversation:$actorKey'),
      actorName,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> _showStandaloneNotification({
    required String? type,
    required String notificationId,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _notificationChannelId,
        _notificationChannelName,
        channelDescription: _notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        category: type == 'friend_request'
            ? AndroidNotificationCategory.social
            : AndroidNotificationCategory.event,
      ),
    );
    await _localNotifications.show(
      _stableNotificationId('standalone:$notificationId'),
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> clearChatNotificationsForAccount(int accountId) async {
    if (!_isAndroid) return;
    final actorKey = accountId.toString();
    try {
      await _localNotifications.cancel(
        _stableNotificationId('conversation:$actorKey'),
        tag: 'conversation_$actorKey',
      );
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('$_conversationStoragePrefix$actorKey');
    } catch (error, stackTrace) {
      logger.w(
        'Could not clear chat notifications for account $accountId',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void _handleOpenedRemoteMessage(RemoteMessage message) {
    unawaited(_clearAllNotifications());
    _handleRemoteMessage(message);
  }

  static void _handleRemoteMessage(RemoteMessage message) {
    _handleData(message.data);
  }

  static Future<void> _clearAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      final preferences = await SharedPreferences.getInstance();
      final conversationKeys = preferences
          .getKeys()
          .where((key) => key.startsWith(_conversationStoragePrefix))
          .toList(growable: false);
      await Future.wait(conversationKeys.map(preferences.remove));
    } catch (error, stackTrace) {
      logger.w(
        'Could not clear Android notifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _migrateStoredNotifications() async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getInt(_notificationStorageVersionKey) ==
        _notificationStorageVersion) {
      return;
    }
    await _localNotifications.cancelAll();
    final conversationKeys = preferences
        .getKeys()
        .where((key) => key.startsWith(_conversationStoragePrefix))
        .toList(growable: false);
    await Future.wait(conversationKeys.map(preferences.remove));
    await preferences.setInt(
      _notificationStorageVersionKey,
      _notificationStorageVersion,
    );
  }

  static Future<List<_StoredNotificationMessage>> _storeConversationMessage({
    required String actorKey,
    required String notificationId,
    required String text,
    required DateTime sentAt,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final storageKey = '$_conversationStoragePrefix$actorKey';
    final storedValue = preferences.getString(storageKey);
    final messages = <_StoredNotificationMessage>[];
    if (storedValue != null) {
      try {
        final decoded = jsonDecode(storedValue);
        if (decoded is List) {
          messages.addAll(
            decoded
                .map(_StoredNotificationMessage.fromJson)
                .whereType<_StoredNotificationMessage>(),
          );
        }
      } catch (_) {
        await preferences.remove(storageKey);
      }
    }

    if (!messages.any((message) => message.id == notificationId)) {
      messages.add(
        _StoredNotificationMessage(
          id: notificationId,
          text: text,
          timestamp: sentAt,
        ),
      );
    }
    messages
        .sort((first, second) => first.timestamp.compareTo(second.timestamp));
    if (messages.length > _maximumStoredMessages) {
      messages.removeRange(0, messages.length - _maximumStoredMessages);
    }
    await preferences.setString(
      storageKey,
      jsonEncode(messages.map((message) => message.toJson()).toList()),
    );
    return messages;
  }

  static Future<ByteArrayAndroidIcon?> _loadActorIcon(String? value) async {
    final imageUrl = value?.trim();
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.hasScheme) return null;
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode != 200 ||
          response.bodyBytes.isEmpty ||
          response.bodyBytes.length > 4 * 1024 * 1024) {
        return null;
      }
      return ByteArrayAndroidIcon(response.bodyBytes);
    } catch (_) {
      return null;
    }
  }

  static int _stableNotificationId(String value) {
    var hash = 0;
    for (final codeUnit in value.codeUnits) {
      hash = ((hash * 31) + codeUnit) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  static void _handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        _handleData(decoded.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ));
      }
    } catch (error, stackTrace) {
      logger.w(
        'Could not read notification payload',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void _handleData(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final actorAccountId = int.tryParse(
      data['actor_account_id']?.toString() ?? '',
    );
    final entityId = int.tryParse(data['entity_id']?.toString() ?? '');
    final navigationType = switch (type) {
      'chat_message' => PushNavigationType.chat,
      'friend_request' => PushNavigationType.friendRequests,
      'shopping_list_invitation' ||
      'meal_plan_invitation' =>
        PushNavigationType.sharedInvitations,
      _ => null,
    };
    if (navigationType == null) return;
    navigationTarget.value = PushNavigationTarget(
      type: navigationType,
      actorAccountId: actorAccountId,
      entityId: entityId,
    );
  }
}
