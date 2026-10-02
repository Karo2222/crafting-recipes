import 'dart:async';

import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Realtime {
  static RealtimeChannel? _channel;
  static StreamSubscription<AuthState>? _authSubscription;
  static Timer? _syncDebounce;
  static Timer? _reconnectTimer;
  static bool _syncRunning = false;
  static bool _syncRequested = false;
  static bool _connectionWarningLogged = false;
  static bool _connecting = false;
  static bool _refreshSessionBeforeConnect = false;
  static bool _running = false;
  static bool _stopping = false;
  static int _reconnectAttempt = 0;

  static void start() {
    _running = true;
    _stopping = false;
    _listenForAuthChanges();
    _scheduleReconnect(immediately: true);
  }

  static void _listenForAuthChanges() {
    _authSubscription ??= supabase.auth.onAuthStateChange.listen((state) {
      switch (state.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          if (state.session != null && _channel == null) {
            _refreshSessionBeforeConnect = false;
            _reconnectTimer?.cancel();
            _reconnectTimer = null;
            _scheduleReconnect(immediately: true);
          }
          break;
        case AuthChangeEvent.signedOut:
          _reconnectTimer?.cancel();
          _reconnectTimer = null;
          unawaited(_removeCurrentChannel());
          break;
        case _:
          break;
      }
    });
  }

  static void _scheduleReconnect({bool immediately = false}) {
    if (!_running ||
        _stopping ||
        currentAccount == null ||
        supabase.auth.currentSession == null ||
        _channel != null ||
        _connecting ||
        _reconnectTimer?.isActive == true) {
      return;
    }

    const retrySeconds = [1, 2, 4, 8, 16, 30];
    final retryIndex = _reconnectAttempt < retrySeconds.length
        ? _reconnectAttempt
        : retrySeconds.length - 1;
    final delay = immediately
        ? Duration.zero
        : Duration(seconds: retrySeconds[retryIndex]);
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(_connect());
    });
  }

  static Future<void> _connect() async {
    if (!_running || _stopping || _channel != null || _connecting) return;
    final accountId = currentAccount;
    var session = supabase.auth.currentSession;
    if (accountId == null || session == null) return;

    _connecting = true;
    try {
      if (_refreshSessionBeforeConnect || session.isExpired) {
        final response = await supabase.auth.refreshSession();
        session = response.session;
        _refreshSessionBeforeConnect = false;
      }
      if (!_running || _stopping || session == null) return;

      await supabase.realtime.setAuth(session.accessToken);
      final channel = supabase.channel('app-sync-$accountId');
      _channel = channel;
      channel
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        callback: (_) => _scheduleSync(),
      )
          .subscribe((status, [error]) {
        if (!identical(_channel, channel)) return;
        switch (status) {
          case RealtimeSubscribeStatus.subscribed:
            _reconnectAttempt = 0;
            _connectionWarningLogged = false;
            _scheduleSync();
            break;
          case RealtimeSubscribeStatus.timedOut:
          case RealtimeSubscribeStatus.channelError:
            _logConnectionWarning(status, error);
            unawaited(_recoverFromChannelFailure(channel, error));
            break;
          case RealtimeSubscribeStatus.closed:
            if (!_stopping) {
              _logConnectionWarning(status, error);
              unawaited(_recoverFromChannelFailure(channel, error));
            }
            break;
        }
      });
    } catch (error) {
      try {
        await _removeCurrentChannel();
      } catch (_) {
        // The failed channel may already have removed itself.
      }
      _logConnectionWarning(RealtimeSubscribeStatus.channelError, error);
      _reconnectAttempt += 1;
    } finally {
      _connecting = false;
      if (_channel == null) _scheduleReconnect();
    }
  }

  static Future<void> _recoverFromChannelFailure(
    RealtimeChannel failedChannel,
    Object? error,
  ) async {
    if (!identical(_channel, failedChannel)) return;
    _channel = null;
    if (error.toString().contains('InvalidJWTToken')) {
      _refreshSessionBeforeConnect = true;
    }
    _reconnectAttempt += 1;
    try {
      await supabase.removeChannel(failedChannel);
    } catch (_) {
      // A failed channel may already have removed itself.
    }
    _scheduleReconnect();
  }

  static Future<void> _removeCurrentChannel() async {
    final channel = _channel;
    _channel = null;
    if (channel != null) await supabase.removeChannel(channel);
  }

  static Future<void> stop() async {
    _running = false;
    _stopping = true;
    _syncDebounce?.cancel();
    _syncDebounce = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _syncRequested = false;
    await _authSubscription?.cancel();
    _authSubscription = null;

    await _removeCurrentChannel();

    _reconnectAttempt = 0;
    _refreshSessionBeforeConnect = false;
    _connectionWarningLogged = false;
    _stopping = false;
  }

  static void _scheduleSync() {
    _syncDebounce?.cancel();
    _syncDebounce = Timer(const Duration(milliseconds: 500), _queueSync);
  }

  static void _queueSync() {
    _syncRequested = true;
    if (!_syncRunning) unawaited(_drainSyncRequests());
  }

  static Future<void> _drainSyncRequests() async {
    _syncRunning = true;
    try {
      while (_syncRequested) {
        _syncRequested = false;
        await sync();
      }
    } finally {
      _syncRunning = false;
    }
  }

  static void _logConnectionWarning(
    RealtimeSubscribeStatus status,
    Object? error,
  ) {
    if (_connectionWarningLogged) return;
    _connectionWarningLogged = true;
    final details = error == null ? '' : ': $error';
    logger.w('Realtime connection unavailable (${status.name})$details');
  }

  static Future<void> sync() async {
    try {
      final accountId = currentAccount;
      if (accountId == null) return;

      final settings = await Singleton().getDatabase().getRealtime(accountId);
      if (settings.firstOrNull?.realtime == true) {
        await SupabaseToDrift.sync();
      }
    } catch (error, stackTrace) {
      logger.w(
        'Realtime sync will retry later',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Stream getHistoryStream() {
    if (currentAccount == null) return const Stream.empty();

    return supabase
        .from('history')
        .stream(primaryKey: ['account_id', 'recipe_id'])
        .eq('account_id', currentAccount!)
        .limit(1);
  }
}
