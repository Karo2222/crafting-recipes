import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Returns to the app's primary tab before allowing the platform to leave it.
class RootTabBackScope extends StatelessWidget {
  const RootTabBackScope({
    super.key,
    required this.isOnRootTab,
    required this.onReturnToRootTab,
    this.currentTabCanPop = false,
    this.onPopCurrentTab,
    required this.child,
  });

  final bool isOnRootTab;
  final VoidCallback onReturnToRootTab;
  final bool currentTabCanPop;
  final VoidCallback? onPopCurrentTab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: isOnRootTab && !currentTabCanPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentTabCanPop) {
          onPopCurrentTab?.call();
          return;
        }
        if (!isOnRootTab) onReturnToRootTab();
      },
      child: child,
    );
  }
}

/// Uses the native interactive edge-swipe on iOS while preserving Material
/// navigation and system-back gestures on Android and other platforms.
Route<T> appPageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
  bool fullscreenDialog = false,
  bool fullScreenSwipeBack = false,
}) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    if (fullScreenSwipeBack) {
      return _FullScreenSwipeCupertinoPageRoute<T>(
        builder: builder,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }
    return CupertinoPageRoute<T>(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  return MaterialPageRoute<T>(
    builder: builder,
    settings: settings,
    fullscreenDialog: fullscreenDialog,
  );
}

Route<T> appReversePageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
  VoidCallback? onTransitionCompleted,
}) {
  return _ReversePageRoute<T>(
    builder: builder,
    settings: settings,
    onTransitionCompleted: onTransitionCompleted,
  );
}

class _ReversePageRoute<T> extends PageRouteBuilder<T> {
  _ReversePageRoute({
    required WidgetBuilder builder,
    super.settings,
    this.onTransitionCompleted,
  }) : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );
            return SlideTransition(position: position, child: child);
          },
        );

  final VoidCallback? onTransitionCompleted;
  bool _notified = false;

  @override
  TickerFuture didPush() {
    final ticker = super.didPush();
    ticker.whenCompleteOrCancel(() {
      if (_notified) return;
      _notified = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onTransitionCompleted?.call();
      });
    });
    return ticker;
  }
}

class _FullScreenSwipeCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  _FullScreenSwipeCupertinoPageRoute({
    required super.builder,
    super.settings,
    super.fullscreenDialog,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final transition = super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
    return _FullScreenBackGestureDetector<T>(
      enabledCallback: () => !fullscreenDialog && popGestureEnabled,
      onStartPopGesture: () => _FullScreenBackGestureController<T>(
        navigator: navigator!,
        controller: controller!,
        getIsActive: () => isActive,
        getIsCurrent: () => isCurrent,
      ),
      child: transition,
    );
  }
}

class _FullScreenBackGestureDetector<T> extends StatefulWidget {
  const _FullScreenBackGestureDetector({
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_FullScreenBackGestureController<T>> onStartPopGesture;
  final Widget child;

  @override
  State<_FullScreenBackGestureDetector<T>> createState() =>
      _FullScreenBackGestureDetectorState<T>();
}

class _FullScreenBackGestureDetectorState<T>
    extends State<_FullScreenBackGestureDetector<T>> {
  late final HorizontalDragGestureRecognizer _recognizer;
  _FullScreenBackGestureController<T>? _backGestureController;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    final activeController = _backGestureController;
    if (activeController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (activeController.navigator.mounted) {
          activeController.navigator.didStopUserGesture();
        }
      });
      _backGestureController = null;
    }
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _backGestureController?.dragUpdate(
      _toLogicalDirection(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    _backGestureController?.dragEnd(
      _toLogicalDirection(
        details.velocity.pixelsPerSecond.dx / context.size!.width,
      ),
    );
    _backGestureController = null;
  }

  void _handleDragCancel() {
    _backGestureController?.dragEnd(0);
    _backGestureController = null;
  }

  double _toLogicalDirection(double value) {
    return Directionality.of(context) == TextDirection.rtl ? -value : value;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      child: widget.child,
    );
  }
}

class _FullScreenBackGestureController<T> {
  _FullScreenBackGestureController({
    required this.navigator,
    required this.controller,
    required this.getIsActive,
    required this.getIsCurrent,
  }) {
    navigator.didStartUserGesture();
  }

  static const _minimumFlingVelocity = 1.0;
  static const _settleDuration = Duration(milliseconds: 350);

  final AnimationController controller;
  final NavigatorState navigator;
  final ValueGetter<bool> getIsActive;
  final ValueGetter<bool> getIsCurrent;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    const animationCurve = Curves.fastEaseInToSlowEaseOut;
    final isCurrent = getIsCurrent();
    final bool returnToPage;

    if (!isCurrent) {
      returnToPage = getIsActive();
    } else if (velocity.abs() >= _minimumFlingVelocity) {
      returnToPage = velocity <= 0;
    } else {
      returnToPage = controller.value > 0.5;
    }

    if (returnToPage) {
      controller.animateTo(
        1,
        duration: _settleDuration,
        curve: animationCurve,
      );
    } else {
      if (isCurrent) {
        navigator.pop();
      }
      if (controller.isAnimating) {
        controller.animateBack(
          0,
          duration: _settleDuration,
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener stopGesture;
      stopGesture = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(stopGesture);
      };
      controller.addStatusListener(stopGesture);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
