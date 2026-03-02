part of '../core.dart';

class DialogDeferralResult<V> {
  bool success;
  V? dialogValue;

  DialogDeferralResult.fail() : success = false;

  DialogDeferralResult.success({
    required this.dialogValue,
  }) : success = true;
}

class _StorageDeferment {
  final _Storage _storage;

  DefermentSource? __defermentSource;

  bool __freezeTemporarilyOnce = false;

  bool get freezeTemporarilyOnce => __freezeTemporarilyOnce;

  void _resetFreezeTemporarilyOnce() {
    __freezeTemporarilyOnce = false;
  }

  _StorageDeferment(_Storage storage) : _storage = storage;

  bool get isFreezing {
    if (__freezeTemporarilyOnce) {
      return true;
    }
    return __defermentSource != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __checkDialogAndResumeReactionIfCan({
    required ExecutionTrace executionTrace,
  }) async {
    if (__defermentSource != null) {
      return;
    }
    //
    // SAME-AS: #0003
    Future.delayed(
      Duration.zero,
      () {
        for (String shelfName in _storage._shelfMap.keys) {
          Shelf reactionShelf = _storage._shelfMap[shelfName]!;
          if (reactionShelf._hasReactionBookmark()) {
            reactionShelf._addShelfExternalReactionTaskUnit(
              executionTrace: executionTrace,
            );
          }
        }
        FlutterArtist.executor._executeTaskUnitQueue();
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __checkStartOrEndDrawerAndResumeReactionIfCan({
    required ExecutionTrace executionTrace,
  }) async {
    if (__defermentSource != null) {
      return;
    }
    //
    // SAME-AS:
    Future.delayed(
      Duration.zero,
      () {
        for (String shelfName in _storage._shelfMap.keys) {
          Shelf reactionShelf = _storage._shelfMap[shelfName]!;
          if (reactionShelf._hasReactionBookmark()) {
            reactionShelf._addShelfExternalReactionTaskUnit(
              executionTrace: executionTrace,
            );
          }
        }
        FlutterArtist.executor._executeTaskUnitQueue();
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __ensureDefermentSourceIsNull() {
    if (__defermentSource != null) {
      // TODO: Show notify!
      return false;
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Dialog:
  ///
  Future<DialogDeferralResult<V?>>
      _openDialogAndDeferExternalShelfEventsUntilClosed<V>({
    required Future<V?> Function() openDialog,
    required ExecutionTrace executionTrace,
  }) async {
    if (!__ensureDefermentSourceIsNull()) {
      return DialogDeferralResult<V?>.fail();
    }
    try {
      // --> @see: #0004.
      __defermentSource = DefermentSource.dialog;
      V? value = await openDialog();
      return DialogDeferralResult.success(dialogValue: value);
    } finally {
      __defermentSource = null;
      __checkDialogAndResumeReactionIfCan(
        executionTrace: executionTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Drawer:
  ///
  Future<void> _openDrawerAndDeferExternalShelfEventsUntilClosed(
    BuildContext context, {
    required ExecutionTrace executionTrace,
    bool showSuggestionIfNeed = true,
  }) async {
    if (!__ensureDefermentSourceIsNull()) {
      return;
    }
    Scaffold.of(context).openDrawer();
    __defermentSource = DefermentSource.drawer;
    await Future.delayed(const Duration(milliseconds: 100));
    if (showSuggestionIfNeed && !_storage.drawer._isDrawerOpen) {
      _storage.showErrorSnackBar(
        message:
            "Method openDrawerAndDeferExternalShelfEventsUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugUtils.getFatalError(
          " Method openDrawerAndDeferExternalShelfEventsUntilClosed() is being used incorrectly!\n "
          " @see: https://document.com");
      print(message);
    }
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) {
          return _storage.drawer._isDrawerOpen == true;
        },
      ),
    );
    __defermentSource = null;
    __checkStartOrEndDrawerAndResumeReactionIfCan(
      executionTrace: executionTrace,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// EndDrawer:
  ///
  Future<void> _openEndDrawerAndDeferExternalShelfEventsUntilClosed(
    BuildContext context, {
    required ExecutionTrace executionTrace,
    bool showSuggestionIfNeed = true,
  }) async {
    if (!__ensureDefermentSourceIsNull()) {
      return;
    }
    Scaffold.of(context).openEndDrawer();
    __defermentSource = DefermentSource.endDrawer;
    await Future.delayed(const Duration(milliseconds: 100));
    if (showSuggestionIfNeed && !_storage.endDrawer._isEndDrawerOpen) {
      _storage.showErrorSnackBar(
        message:
            "Method openEndDrawerAndDeferExternalShelfEventsUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugUtils.getFatalError(
          " Method openEndDrawerAndDeferExternalShelfEventsUntilClosed() is being used incorrectly!\n "
          " @see: https://document.com");
      print(message);
    }
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) {
          return _storage.endDrawer._isEndDrawerOpen == true;
        },
      ),
    );
    __defermentSource = null;
    __checkStartOrEndDrawerAndResumeReactionIfCan(
      executionTrace: executionTrace,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Freeze Once:
  ///
  void _freezeReactionBetweenShelvesOnce() {
    __freezeTemporarilyOnce = true;
  }
}
