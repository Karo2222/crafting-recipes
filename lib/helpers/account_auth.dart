import 'dart:async';

import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/realtime.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/push_notifications.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/cancellation.dart';

class LinkedAccountSession {
  const LinkedAccountSession({
    required this.accountId,
    required this.profileId,
  });

  final int accountId;
  final int profileId;
}

class AccountAuth {
  static Future<LinkedAccountSession?> findLinkedAccount() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return null;

    var accountId = await SupabaseToDrift.getCurrentAccountId();
    int? profileId;
    if (accountId == null) {
      final registration = await SupabaseToDrift.completeAccountRegistration();
      accountId = (registration[Const.accountId.key] as num).toInt();
      profileId = (registration[Const.profileId.key] as num).toInt();
    }

    profileId ??= await SupabaseToDrift.getMainProfileIdForAccount(accountId);
    if (profileId == null) return null;
    return LinkedAccountSession(
      accountId: accountId,
      profileId: profileId,
    );
  }

  static Future<bool> activateCurrentUser() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return false;
    final linkedAccount = await findLinkedAccount();
    if (linkedAccount == null) return false;

    await KeyValue.setCurrentAccount(linkedAccount.accountId);
    await KeyValue.setCurrentProfile(linkedAccount.profileId);
    await KeyValue.setCurrentAuthUser(authUser.id);
    currentAccount = linkedAccount.accountId;
    currentProfile = linkedAccount.profileId;

    try {
      await SupabaseToDrift.initializeAccounts();
      await SupabaseToDrift.initializeSettings();
    } catch (error, stackTrace) {
      await KeyValue.saveSyncStatus(SyncStatus.pendingSync);
      logger.w(
        'Account activated with cached data; initial sync will retry',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      final deviceId = await DeviceInfo.getDeviceId();
      if (deviceId != null && deviceId.isNotEmpty) {
        await DriftToSupabase.registerDevice(deviceId);
      }
    } catch (error) {
      logger.w('Device registration will retry later: $error');
    }
    DriftToSupabase.initializeOfflineSync();
    Realtime.start();
    unawaited(PushNotifications.startForAccount(linkedAccount.accountId));
    return true;
  }

  static Future<bool> restoreSession() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) {
      await clearLocalIdentity();
      return false;
    }

    final savedAuthUser = await KeyValue.getCurrentAuthUser();
    final savedAccount = await KeyValue.getCurrentAccount();
    final savedProfile = await KeyValue.getCurrentProfile();
    if (savedAuthUser == authUser.id &&
        savedAccount != null &&
        savedProfile != null) {
      currentAccount = savedAccount;
      currentProfile = savedProfile;
      unawaited(PushNotifications.startForAccount(savedAccount));
      unawaited(
        SupabaseToDrift.refreshCurrentAccountRealtimeData().catchError(
          (Object error, StackTrace stackTrace) {
            logger.w(
              'Chat refresh will retry later',
              error: error,
              stackTrace: stackTrace,
            );
          },
        ),
      );
      return true;
    }

    final activated = await activateCurrentUser();
    if (!activated) await clearLocalIdentity();
    return activated;
  }

  static Future<void> clearLocalIdentity() async {
    await KeyValue.clearCurrentIdentity();
    currentAccount = null;
    currentProfile = null;
  }

  static Future<void> signOut({bool clearIdentity = true}) async {
    await Realtime.stop();
    await PushNotifications.stopForAccount(currentAccount);
    await supabase.auth.signOut();
    if (clearIdentity) await clearLocalIdentity();
  }
}
