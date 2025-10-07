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

  Future<void> __checkDialogAndResumeReactionIfCan() async {
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
            reactionShelf._addShelfExternalReactionTaskUnit();
          }
        }
        FlutterArtist.executor._executeTaskUnitQueue();
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __checkStartOrEndDrawerAndResumeReactionIfCan() async {
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
            reactionShelf._addShelfExternalReactionTaskUnit();
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
      _openDialogThenFreezeReactionBetweenShelvesUntilClosed<V>({
    required Future<V?> Function() openDialog,
  }) async {
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
      __checkDialogAndResumeReactionIfCan();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Drawer:
  ///
  Future<void> _openDrawerThenFreezeReactionBetweenShelvesUntilClosed(
    BuildContext context, {
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
            "Method openDrawerThenFreezeReactionBetweenShelvesUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugUtils.getFatalError(
          " Method openDrawerThenFreezeReactionBetweenShelvesUntilClosed() is being used incorrectly!\n "
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
    __checkStartOrEndDrawerAndResumeReactionIfCan();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// EndDrawer:
  ///
  Future<void> _openEndDrawerThenFreezeReactionBetweenShelvesUntilClosed(
    BuildContext context, {
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
    __checkStartOrEndDrawerAndResumeReactionIfCan();
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
