part of '../core.dart';

class FreezeByDialogResult<V> {
  bool success;
  V? dialogValue;

  FreezeByDialogResult.fail() : success = false;

  FreezeByDialogResult.success({
    required this.dialogValue,
  }) : success = true;
}

class _Stocker {
  final _Storage _storage;

  FreezeType? __freezeType;

  bool __freezeTemporarilyOnce = false;

  bool get freezeTemporarilyOnce => __freezeTemporarilyOnce;

  void _resetFreezeTemporarilyOnce() {
    __freezeTemporarilyOnce = false;
  }

  _Stocker(_Storage storage) : _storage = storage;

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

  Future<void> __checkEndDrawerAndResumeReactionIfCan() async {
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

  // Dialog:
  @_RootMethodAnnotation()
  Future<FreezeByDialogResult<V?>> openDialogThenFreezeReactionUntilClosed<V>({
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

  @_RootMethodAnnotation()
  Future<void> openEndDrawerThenFreezeReactionUntilClosed(
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
            "Method openEndDrawerThenFreezeReactionUntilClosed() is being used incorrectly. "
            "See console for more details.",
        errorDetails: null,
      );
      String message = DebugPrint.getFatalError(
          " Method openEndDrawerThenFreezeReactionUntilClosed() is being used incorrectly!\n "
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
    __checkEndDrawerAndResumeReactionIfCan();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Called by Storage.
  ///
  void _freezeReactionToExternalShelfEventsOnce() {
    __freezeTemporarilyOnce = true;
  }
}
