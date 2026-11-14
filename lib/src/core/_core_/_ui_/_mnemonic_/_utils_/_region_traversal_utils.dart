part of '../../../core.dart';

/// Utility class managing global shortcut triggers (`F1`), keyboard region
/// cycling (`Ctrl + \`` and `Ctrl + Shift + \``), and initial focus rescue
/// across FlutterArtist views.
class RegionTraversalUtils {
  static bool _globalHandlerInstalled = false;
  static bool _isShortcutDialogOpen = false;
  static KeyEvent? _lastHandledEvent;

  /// Installs a global [HardwareKeyboard] handler once so that region switching
  /// and help shortcuts work even when focus initially resides outside
  /// FlutterArtist (e.g., inside a third-party application shell or scaffold).
  static void ensureGlobalHandlerInstalled() {
    if (_globalHandlerInstalled) return;
    _globalHandlerInstalled = true;
    HardwareKeyboard.instance.addHandler(_handleGlobalHardwareKeyEvent);
  }

  static bool _handleGlobalHardwareKeyEvent(KeyEvent event) {
    return handleRegionTraversalKeyEvent(event) == KeyEventResult.handled;
  }

  /// Evaluates [event] against global help (`F1`) and [MnemonicRegionDirection]
  /// shortcuts across active regions on the current top-most layer.
  static KeyEventResult handleRegionTraversalKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    // Prevent duplicate handling when both local Focus onKeyEvent and the
    // global HardwareKeyboard handler observe the same KeyEvent instance.
    if (identical(_lastHandledEvent, event)) {
      return KeyEventResult.handled;
    }

    final HardwareKeyboard keyboard = HardwareKeyboard.instance;

    // 1. Global F1 shortcut -> Open context-aware Keyboard Shortcuts Dialog
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.f1 &&
        !keyboard.isControlPressed &&
        !keyboard.isAltPressed &&
        !keyboard.isMetaPressed &&
        !keyboard.isShiftPressed) {
      if (!_isShortcutDialogOpen &&
          !FlutterArtist.navigatorObserver.topRouteIsPopupRoute) {
        _markEventHandled(event);
        _isShortcutDialogOpen = true;
        KeyboardShortcutsDialog.show().whenComplete(() {
          _isShortcutDialogOpen = false;
        });
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // 2. Region traversal (Ctrl + ` / Ctrl + Shift + `)
    final bool isNext = MnemonicRegionDirection.next.matches(event, keyboard);
    final bool isPrevious =
        MnemonicRegionDirection.previous.matches(event, keyboard);

    if (!isNext && !isPrevious) {
      return KeyEventResult.ignored;
    }

    _markEventHandled(event);

    final List<_FocusableViewRegionState> regions =
        _RegionDispatcher.getActiveRouteRegions();
    if (regions.isEmpty) {
      return KeyEventResult.ignored;
    }

    final int currentIndex =
        regions.indexWhere((region) => region.hasRegionFocus);

    // Rescue focus into FlutterArtist if focus is currently outside all managed regions.
    if (currentIndex == -1) {
      final _FocusableViewRegionState entryRegion =
          isNext ? regions.first : regions.last;
      entryRegion.requestRegionFocus();
      return KeyEventResult.handled;
    }

    // Cycle to the next or previous region with wrap-around.
    int targetIndex = isNext ? currentIndex + 1 : currentIndex - 1;
    if (targetIndex >= regions.length) {
      targetIndex = 0;
    } else if (targetIndex < 0) {
      targetIndex = regions.length - 1;
    }

    regions[targetIndex].requestRegionFocus();
    return KeyEventResult.handled;
  }

  /// Focuses the first eligible region on the current top-most layer if no
  /// FlutterArtist region currently holds focus.
  static void ensureInitialFocusOnCurrentRoute() {
    final List<_FocusableViewRegionState> regions =
        _RegionDispatcher.getActiveRouteRegions();
    if (regions.isEmpty) return;

    final bool alreadyFocused = regions.any((region) => region.hasRegionFocus);
    if (!alreadyFocused) {
      regions.first.requestRegionFocus();
    }
  }

  static void _markEventHandled(KeyEvent event) {
    _lastHandledEvent = event;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _lastHandledEvent = null;
    });
  }
}
