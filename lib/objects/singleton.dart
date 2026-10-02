import 'package:flutter/foundation.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Download progress of a single table during a sync.
class ProgressFraction {
  ProgressFraction(this.synced, this.total, this.tablename);

  int synced;
  int total;
  String tablename;

  @override
  String toString() => '$synced/$total, $tablename';
}

/// App-wide services and observable sync state.
///
/// The database, shared preferences and the sync progress live here so that
/// views can listen to them without passing them through the widget tree.
class Singleton {
  factory Singleton() => _instance;
  Singleton._();

  static final Singleton _instance = Singleton._();

  final AppDatabase _database = AppDatabase();
  final CancellationToken _cancelToken = CancellationToken();
  Future<SharedPreferences>? _preferences;

  final _status = ValueNotifier<SyncStatus>(SyncStatus.neverSynced);
  final _lastError = ValueNotifier<String?>(null);
  final _uploadIssue = ValueNotifier<SyncUploadIssue?>(null);
  final _syncedTables = ValueNotifier<int>(0);
  final _syncSteps = ValueNotifier<int>(0);
  final _tableProgress = ValueNotifier<List<ProgressFraction>>(const []);

  // Services

  AppDatabase getDatabase() => _database;

  Future<SharedPreferences> getPrefInstance() =>
      _preferences ??= SharedPreferences.getInstance();

  CancellationToken getCancelToken() => _cancelToken;

  // Sync status

  SyncStatus getSyncStatus() => _status.value;
  bool getSyncing() => _status.value == SyncStatus.runningSync;
  ValueNotifier<SyncStatus> getValueNotifierSyncStatus() => _status;
  void setSyncStatus({required SyncStatus newStatus}) =>
      _status.value = newStatus;

  ValueNotifier<String?> getLastSyncError() => _lastError;
  void setLastSyncError(String? error) => _lastError.value = error;

  ValueNotifier<SyncUploadIssue?> getSyncUploadIssue() => _uploadIssue;
  void setSyncUploadIssue(SyncUploadIssue? issue) {
    if (issue?.fingerprint != _uploadIssue.value?.fingerprint) {
      _uploadIssue.value = issue;
    }
  }

  // Sync progress

  ValueNotifier<int> getNumberofSynchedTables() => _syncedTables;
  void setNumberOfSyncedTables({required int numberOfSyncedTables}) =>
      _syncedTables.value = numberOfSyncedTables;
  void incrementNumberOfSyncedTables() => _syncedTables.value += 1;
  void resetNumberOfSyncedTables() => _syncedTables.value = 0;

  ValueNotifier<int> getNumberOfSyncSteps() => _syncSteps;
  void setNumberOfSyncSteps({required int numberOfSyncSteps}) =>
      _syncSteps.value = numberOfSyncSteps;

  ValueNotifier<List<ProgressFraction>> getPercentageOfSyncedEntries() =>
      _tableProgress;

  /// Registers a new table and notifies listeners.
  void addAndUpdate(ProgressFraction progress) =>
      _tableProgress.value = [..._tableProgress.value, progress];

  /// Notifies listeners after a [ProgressFraction] was changed in place.
  void updateNotifier() =>
      _tableProgress.value = List.of(_tableProgress.value);

  void resetPercentageOfSyncedEntries() => _tableProgress.value = const [];
}
