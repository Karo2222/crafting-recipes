import 'dart:async';
import 'dart:convert';

import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:xid/xid.dart';

typedef MutationDispatcher = Future<void> Function(
  String mutationType,
  Map<String, dynamic> payload,
);
typedef ReconnectHandler = Future<void> Function();
typedef SyncAvailabilityCheck = bool Function();

class OfflineMutationConflictException implements Exception {
  const OfflineMutationConflictException(this.message);

  final String message;
}

class OfflineMutationRejectedException implements Exception {
  const OfflineMutationRejectedException(this.message);

  final String message;
}

class OfflineMutationQueue with WidgetsBindingObserver {
  OfflineMutationQueue._();

  static final OfflineMutationQueue instance = OfflineMutationQueue._();
  static const int maxWebSafeInteger = 9007199254740991;

  MutationDispatcher? _dispatcher;
  ReconnectHandler? _onReconnect;
  SyncAvailabilityCheck? _canSync;
  Future<void>? _activeFlush;
  Future<void>? _activeReconnect;
  Timer? _retryTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  int _retryIndex = 0;
  bool _started = false;
  final Set<String> _loggedBlockedIssueFingerprints = {};
  final Set<int> _retriedBlockedMutationAccounts = {};

  void start(
    MutationDispatcher dispatcher, {
    required ReconnectHandler onReconnect,
    required SyncAvailabilityCheck canSync,
  }) {
    _dispatcher = dispatcher;
    _onReconnect = onReconnect;
    _canSync = canSync;
    if (!_started) {
      WidgetsBinding.instance.addObserver(this);
      _connectivitySubscription ??=
          Connectivity().onConnectivityChanged.listen((results) {
        if (results.any((result) => result != ConnectivityResult.none)) {
          _retryTimer?.cancel();
          _retryTimer = null;
          unawaited(_syncAfterReconnect());
        }
      });
      _started = true;
    }
    unawaited(_syncAfterReconnect());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_syncAfterReconnect());
    }
  }

  Future<void> _syncAfterReconnect() async {
    if (_canSync?.call() != true) return;
    final running = _activeReconnect;
    if (running != null) return running;
    final accountId = currentAccount;
    final operation = _runReconnectSync();
    _activeReconnect = operation;
    try {
      await operation;
    } finally {
      _activeReconnect = null;
      if (accountId != currentAccount && _canSync?.call() == true) {
        unawaited(_syncAfterReconnect());
      }
    }
  }

  Future<void> _runReconnectSync() async {
    final accountId = currentAccount;
    try {
      await flush();
      if (accountId == null || currentAccount != accountId) return;
      final handler = _onReconnect;
      if (handler == null) return;
      await handler();
    } catch (error, stackTrace) {
      logger.w(
        'Reconnect synchronization will retry.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static int createLocalId() {
    final digest = sha256.convert(utf8.encode(Xid().toString())).bytes;
    var value = 0;
    for (var index = 0; index < 6; index++) {
      value = value * 256 + digest[index];
    }
    return -(value == 0 ? 1 : value);
  }

  Future<String> enqueue(
    String mutationType,
    Map<String, dynamic> payload, {
    required int accountId,
    String? entityKey,
  }) async {
    if (currentAccount != accountId) {
      throw StateError('Cannot queue a change for an inactive account.');
    }
    final id = Xid().toString();
    final database = Singleton().getDatabase();
    payload['_mutation_id'] = id;
    if (entityKey != null) {
      payload['_entity_key'] = entityKey;
      final existing = await database.getAllPendingMutations();
      for (final mutation in existing) {
        final decoded = jsonDecode(mutation.payload);
        if (mutation.accountId == accountId &&
            decoded is Map &&
            decoded['_entity_key'] == entityKey) {
          await database.deletePendingMutation(mutation.id);
        }
      }
    }
    await database.enqueueMutation(
      PendingMutationsCompanion.insert(
        id: id,
        accountId: Value(accountId),
        mutationType: mutationType,
        payload: jsonEncode(payload),
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await KeyValue.saveSyncStatus(SyncStatus.pendingSync);
    _scheduleRetry();
    unawaited(_syncAfterReconnect());
    return id;
  }

  Future<void> flush() async {
    final running = _activeFlush;
    if (running != null) return running;
    final dispatcher = _dispatcher;
    if (dispatcher == null) return;

    final operation = _flushPending(dispatcher);
    _activeFlush = operation;
    try {
      await operation;
    } finally {
      _activeFlush = null;
    }
    await _reportBlockedMutation();
  }

  Future<void> _reportBlockedMutation() async {
    final accountId = currentAccount;
    if (accountId == null) return;
    final mutations = await _accountMutations(accountId);
    final blocked = mutations.where((mutation) => mutation.blocked).firstOrNull;
    if (blocked == null) {
      _loggedBlockedIssueFingerprints.clear();
      Singleton().setSyncUploadIssue(null);
      return;
    }
    final issue = SyncUploadIssue(
      mutationType: blocked.mutationType,
      reason: blocked.lastError ?? 'Upload was rejected.',
    );
    _logBlockedIssue(issue);
    Singleton().setSyncUploadIssue(issue);
  }

  void _logBlockedIssue(SyncUploadIssue issue) {
    if (!_loggedBlockedIssueFingerprints.add(issue.fingerprint)) return;
    logger.w(
      'Upload blocked: ${issue.mutationType}',
      error: issue.reason,
    );
  }

  Future<bool> hasBlockedEntity(String entityKey) async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    final mutations = await _accountMutations(accountId);
    for (final mutation in mutations.where((item) => item.blocked)) {
      final decoded = jsonDecode(mutation.payload);
      if (decoded is Map && decoded['_entity_key'] == entityKey) return true;
    }
    return false;
  }

  Future<bool> hasBlockedMutations() async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    return (await _accountMutations(accountId))
        .any((mutation) => mutation.blocked);
  }

  Future<bool> hasPendingRecipeMutations() async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    final mutations = await _accountMutations(accountId);
    return mutations.any(
      (mutation) =>
          mutation.mutationType == 'recipe_create' ||
          mutation.mutationType == 'recipe_update',
    );
  }

  Future<bool> hasPendingMutationsWithPrefix(String prefix) async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    final mutations = await _accountMutations(accountId);
    return mutations.any(
      (mutation) => mutation.mutationType.startsWith(prefix),
    );
  }

  Future<Set<int>> pendingRowIdsForMutation(String mutationType) async {
    final accountId = currentAccount;
    if (accountId == null) return const {};
    final mutations = await _accountMutations(accountId);
    final ids = <int>{};
    for (final mutation
        in mutations.where((item) => item.mutationType == mutationType)) {
      final decoded = jsonDecode(mutation.payload);
      if (decoded is! Map) continue;
      final id = decoded['id'];
      if (id is num) {
        ids.add(id.toInt());
      } else if (id != null) {
        final parsed = int.tryParse(id.toString());
        if (parsed != null) ids.add(parsed);
      }
    }
    return ids;
  }

  Future<void> removeEntity(String entityKey) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    final database = Singleton().getDatabase();
    final mutations = await _accountMutations(accountId);
    for (final mutation in mutations) {
      final decoded = jsonDecode(mutation.payload);
      if (decoded is Map && decoded['_entity_key'] == entityKey) {
        await database.deletePendingMutation(mutation.id);
      }
    }
  }

  Future<void> _flushPending(MutationDispatcher dispatcher) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    final database = Singleton().getDatabase();
    await _verifyAuthenticatedAccount(accountId);
    await _assignLegacyMutationAccounts();
    if (_retriedBlockedMutationAccounts.add(accountId)) {
      await database.unblockPendingMutationsForAccount(accountId);
    }
    final mutations = await database.getPendingMutationsForAccount(accountId);
    if (mutations.isEmpty) {
      _retryTimer?.cancel();
      _retryTimer = null;
      _retryIndex = 0;
      return;
    }

    for (final mutation in mutations) {
      if (currentAccount != accountId) return;
      if (mutation.mutationType.startsWith('shopping_list_')) {
        logger.i(
          'Dispatching queued shopping-list change: '
          'queueId=${mutation.id}, account=${mutation.accountId}, '
          'type=${mutation.mutationType}, attempt=${mutation.attempts + 1}, '
          'blocked=${mutation.blocked}',
        );
      }
      try {
        await dispatcher(
          mutation.mutationType,
          Map<String, dynamic>.from(jsonDecode(mutation.payload) as Map),
        );
        await database.deletePendingMutation(mutation.id);
        if (mutation.mutationType.startsWith('shopping_list_')) {
          logger.i(
            'Removed uploaded shopping-list change from queue: '
            'queueId=${mutation.id}, type=${mutation.mutationType}',
          );
        }
        _retryIndex = 0;
      } on OfflineMutationConflictException catch (error) {
        await database.markMutationAttempt(
          mutation.id,
          attempts: mutation.attempts + 1,
          error: error.message,
          blocked: true,
        );
        final issue = SyncUploadIssue(
          mutationType: mutation.mutationType,
          reason: error.message,
        );
        _logBlockedIssue(issue);
        Singleton().setSyncUploadIssue(issue);
        if (mutation.mutationType.startsWith('shopping_list_')) {
          logger.w(
            'Shopping-list change remains local and blocked: '
            'queueId=${mutation.id}, type=${mutation.mutationType}, '
            'attempts=${mutation.attempts + 1}',
            error: error.message,
          );
        }
      } on OfflineMutationRejectedException catch (error) {
        logger.w(
          'Pending mutation was rejected permanently: ${mutation.mutationType}',
          error: error,
        );
        await database.deletePendingMutation(mutation.id);
      } catch (error, stackTrace) {
        await database.markMutationAttempt(
          mutation.id,
          attempts: mutation.attempts + 1,
          error: error.toString(),
        );
        logger.w(
          'Pending mutation will retry: ${mutation.mutationType}',
          error: error,
          stackTrace: stackTrace,
        );
        _scheduleRetry();
        return;
      }
    }

    final remaining = await database.getPendingMutationsForAccount(accountId);
    if (remaining.isEmpty) {
      _retryTimer?.cancel();
      _retryTimer = null;
      _retryIndex = 0;
    } else {
      _scheduleRetry();
    }
  }

  Future<void> _verifyAuthenticatedAccount(int accountId) async {
    var session = supabase.auth.currentSession;
    if (session == null) {
      throw StateError('No authenticated session is available for sync.');
    }
    if (session.isExpired) {
      session = (await supabase.auth.refreshSession()).session;
    }
    if (session == null) {
      throw StateError('The authenticated session could not be refreshed.');
    }

    int? remoteAccountId = await _remoteAccountId();
    if (remoteAccountId != accountId) {
      session = (await supabase.auth.refreshSession()).session;
      if (session != null) remoteAccountId = await _remoteAccountId();
    }
    if (remoteAccountId != accountId) {
      logger.w(
        'Sync identity mismatch: local account $accountId, '
        'authenticated account $remoteAccountId',
      );
      throw StateError('The authenticated account does not match local data.');
    }
  }

  Future<int?> _remoteAccountId() async {
    final value = await supabase.rpc('current_account_id');
    return value == null ? null : (value as num).toInt();
  }

  Future<List<PendingMutation>> _accountMutations(int accountId) async {
    await _assignLegacyMutationAccounts();
    return (await Singleton().getDatabase().getAllPendingMutations())
        .where((mutation) => mutation.accountId == accountId)
        .toList();
  }

  Future<void> _assignLegacyMutationAccounts() async {
    final database = Singleton().getDatabase();
    final legacy = (await database.getAllPendingMutations())
        .where((mutation) => mutation.accountId == null);
    for (final mutation in legacy) {
      final payload = Map<String, dynamic>.from(
        jsonDecode(mutation.payload) as Map,
      );
      final accountId = await _legacyMutationAccountId(
        mutation.mutationType,
        payload,
      );
      if (accountId != null) {
        await database.assignPendingMutationAccount(
          mutation.id,
          accountId,
          unblock: mutation.blocked,
        );
      }
    }
  }

  Future<int?> _legacyMutationAccountId(
    String mutationType,
    Map<String, dynamic> payload,
  ) async {
    final updatedBy = payload['updated_by'];
    if (updatedBy is num) return updatedBy.toInt();

    final accountId = payload['account_id'];
    if (accountId is num && !mutationType.endsWith('_member_upsert')) {
      return accountId.toInt();
    }

    final entityKey = payload['_entity_key']?.toString();
    final parts = entityKey?.split(':') ?? const <String>[];
    if (mutationType == 'shopping_list_invitation_response' ||
        mutationType == 'meal_plan_invitation_response' ||
        mutationType == 'chat_reaction_set') {
      return int.tryParse(parts.lastOrNull ?? '');
    }
    if (mutationType == 'chat_messages_read' && parts.length >= 3) {
      return int.tryParse(parts[1]);
    }
    if (mutationType == 'chat_message_send') {
      final messageId = payload['id'];
      if (messageId is num) {
        return (await Singleton().getDatabase().getChatMessage(
                  messageId.toInt(),
                ))
            ?.senderAccountId;
      }
    }
    if (mutationType.startsWith('account_friend_') && parts.length >= 3) {
      final firstId = int.tryParse(parts[1]);
      final secondId = int.tryParse(parts[2]);
      if (firstId != null && secondId != null) {
        return (await Singleton()
                .getDatabase()
                .getAccountFriend(firstId, secondId))
            ?.updatedBy;
      }
    }
    return null;
  }

  void _scheduleRetry() {
    if (_retryTimer?.isActive == true) return;
    const delays = [5, 15, 30, 60, 120, 300];
    final delay = delays[_retryIndex.clamp(0, delays.length - 1)];
    if (_retryIndex < delays.length - 1) _retryIndex += 1;
    _retryTimer = Timer(Duration(seconds: delay), () {
      _retryTimer = null;
      unawaited(_syncAfterReconnect());
    });
  }
}
