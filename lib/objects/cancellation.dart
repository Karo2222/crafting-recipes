/// Thrown by [CancellationToken.throwIfCancellationRequested] once a running
/// operation (for example a sync) has been cancelled by the user.
class CancellationException implements Exception {
  const CancellationException();

  @override
  String toString() => 'Operation was cancelled';
}

/// Cooperative cancellation flag that long-running work checks periodically.
class CancellationToken {
  var _cancelled = false;

  bool get isCancellationRequested => _cancelled;

  void cancel() => _cancelled = true;

  void reset() => _cancelled = false;

  void throwIfCancellationRequested() {
    if (_cancelled) throw const CancellationException();
  }
}

/// State of the local database compared to the server.
enum SyncStatus {
  neverSynced,
  pendingSync,
  fullSync,
  runningSync,
  cancelledSync,
}

/// A local change that could not be uploaded, shown to the user once.
class SyncUploadIssue {
  const SyncUploadIssue({required this.mutationType, required this.reason});

  final String mutationType;
  final String reason;

  /// Used to avoid showing the same issue twice in a row.
  String get fingerprint => '$mutationType\n$reason';
}
