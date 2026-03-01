part of '../core.dart';

class FreezeByDialogResult<V> {
  bool success;
  V? dialogValue;

  FreezeByDialogResult.fail() : success = false;

  FreezeByDialogResult.success({
    required this.dialogValue,
  }) : success = true;
}

class _StorageFreeze {
  final _Storage _storage;

  FreezeType? __freezeType;

  bool __freezeTemporarilyOnce = false;

  bool get freezeTemporarilyOnce => __freezeTemporarilyOnce;

  void _resetFreezeTemporarilyOnce() {
    __freezeTemporarilyOnce = false;
  }

  _StorageFreeze(_Storage storage) : _storage = storage;

  bool get isFreezing {
    if (__freezeTemporarilyOnce) {
      return true;
    }
    return __freezeType != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __checkDialogAndResumeReactionIfCan({
    required ExecutionTrace executionTrace,
  }) async {
    if (__freezeType != null) {
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
    if (__freezeType != null) {
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

  bool __ensureFreezeTypeIsNull() {
    if (__freezeType != null) {
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
  Future<FreezeByDialogResult<V?>>
      _openDialogThenFreezeQueuedEventsUntilClosed<V>(
          {required Future<V?> Function() openDialog,
          required ExecutionTrace executionTrace}) async {
    if (!__ensureFreezeTypeIsNull()) {
      return FreezeByDialogResult<V?>.fail();
    }
    try {
      // --> @see: #0004.
      __freezeType = FreezeType.dialog;
      V? value = await openDialog();
      return FreezeByDialogResult.success(dialogValue: value);
    } finally {
      __freezeType = null;
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
  Future<void> _openDrawerThenFreezeQueuedEventsUntilClosed(
    BuildContext context, {
    required ExecutionTrace executionTrace,
    bool showSuggestionIfNeed = true,
  }) async {
    if (!__ensureFreezeTypeIsNull()) {
      return;
    }
    Scaffold.of(context).openDrawer();
    __freezeType = FreezeType.drawer;
    await Future.delayed(const Duration(milliseconds: 100));
    if (showSuggestionIfNeed && !_storage.drawerState._isDrawerOpen) {
      _storage.showErrorSnackBar(
        message:
            "Method openDrawerThenFreezeQueuedEventsUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugUtils.getFatalError(
          " Method openDrawerThenFreezeQueuedEventsUntilClosed() is being used incorrectly!\n "
          " @see: https://document.com");
      print(message);
    }
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) {
          return _storage.drawerState._isDrawerOpen == true;
        },
      ),
    );
    __freezeType = null;
    __checkStartOrEndDrawerAndResumeReactionIfCan(
      executionTrace: executionTrace,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// EndDrawer:
  ///
  Future<void> _openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
    BuildContext context, {
    required ExecutionTrace executionTrace,
    bool showSuggestionIfNeed = true,
  }) async {
    if (!__ensureFreezeTypeIsNull()) {
      return;
    }
    Scaffold.of(context).openEndDrawer();
    __freezeType = FreezeType.endDrawer;
    await Future.delayed(const Duration(milliseconds: 100));
    if (showSuggestionIfNeed && !_storage.endDrawerState._isEndDrawerOpen) {
      _storage.showErrorSnackBar(
        message:
            "Method openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugUtils.getFatalError(
          " Method openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed() is being used incorrectly!\n "
          " @see: https://document.com");
      print(message);
    }
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) {
          return _storage.endDrawerState._isEndDrawerOpen == true;
        },
      ),
    );
    __freezeType = null;
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
