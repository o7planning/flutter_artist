part of '../core.dart';

class FreezeByDialogResult<V> {
  bool success;
  V? dialogValue;

  FreezeByDialogResult.fail() : success = false;

  FreezeByDialogResult.success({
    required this.dialogValue,
  }) : success = true;
}

class _StorageFreezeMan {
  final _Storage storage;

  FreezeType? __freezeType;

  bool __freezeTemporarilyOnce = false;

  bool get freezeTemporarilyOnce => __freezeTemporarilyOnce;

  void _resetFreezeTemporarilyOnce() {
    __freezeTemporarilyOnce = false;
  }

  final Map<_RefreshableWidgetState, bool> _freezingAgentWidgetStateMap = {};

  _StorageFreezeMan(this.storage);

  bool get isFreezing {
    if (__freezeTemporarilyOnce) {
      return true;
    }
    return __freezeType != null;
  }

  bool get __isFreezingByUI {
    final m = {..._freezingAgentWidgetStateMap};
    for (_RefreshableWidgetState widgetState in m.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool isShowing = _freezingAgentWidgetStateMap[widgetState] ?? false;
      if (isShowing) {
        return true;
      }
    }
    return false;
  }

  void _onVisibilityChanged({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    if (_freezingAgentWidgetStateMap.containsKey(widgetState)) {
      _freezingAgentWidgetStateMap[widgetState] = isShowing;
      __checkFreezeByUIAndResumeReactionIfCan();
    }
  }

  void _onWidgetStateDisposed({
    required _RefreshableWidgetState widgetState,
  }) {
    if (_freezingAgentWidgetStateMap.containsKey(widgetState)) {
      _freezingAgentWidgetStateMap.remove(widgetState);
      __checkFreezeByUIAndResumeReactionIfCan();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check to execute delayed reaction.
  ///
  Future<void> __checkFreezeByUIAndResumeReactionIfCan() async {
    if (__freezeType != FreezeType.uiComponent) {
      return;
    }
    if (__isFreezingByUI) {
      return;
    }
    __freezeType = null;
    //
    // SAME-AS: #0003
    Future.delayed(
      Duration.zero,
      () {
        for (String shelfName in storage._shelfMap.keys) {
          Shelf reactionShelf = storage._shelfMap[shelfName]!;
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

  Future<void> __checkDialogAndResumeReactionIfCan() async {
    if (__freezeType != null) {
      return;
    }
    //
    // SAME-AS: #0003
    Future.delayed(
      Duration.zero,
      () {
        for (String shelfName in storage._shelfMap.keys) {
          Shelf reactionShelf = storage._shelfMap[shelfName]!;
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
  Future<FreezeByDialogResult<V?>>
      _freezeReactionToExternalShelfUntilDialogIsClosed<V>({
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
  /// Called by Storage.
  ///
  Future<bool> _freezeReactionToExternalShelfEvents({
    required List<Shelf> shelves,
    required bool findBlockFragment,
    required bool findForm,
    required bool findScalarFragment,
    required bool highlightUIComponents,
    required int waitForUIReadyInMilliseconds,
  }) async {
    if (!__ensureFreezeTypeIsNull()) {
      return false;
    }
    __freezeType = FreezeType.uiComponent;
    //
    if (waitForUIReadyInMilliseconds >= 0) {
      await Future.delayed(
        Duration(milliseconds: waitForUIReadyInMilliseconds),
      );
    }
    __freezeTemporarilyOnce = false;
    //
    final map = <_RefreshableWidgetState, XState>{};
    for (Shelf shelf in shelves) {
      final m = shelf.ui._findMountedWidgetStates(
        withBlockFragment: true,
        withScalarFragment: true,
        withPagination: true,
        withFilter: false,
        withForm: true,
        withBlockControlBar: true,
        withScalarControlBar: true,
        withControl: false,
        activeOnly: true,
      );
      map.addAll(m);
    }
    if (map.isEmpty) {
      __freezeType = null;
      return false;
    }
    _freezingAgentWidgetStateMap
      ..clear()
      ..addAll(
        map.map(
          (k, v) => MapEntry<_RefreshableWidgetState, bool>(k, v.isShowing),
        ),
      );
    if (highlightUIComponents) {
      for (_RefreshableWidgetState ws in map.keys) {
        ws.showMode == ShowMode.dev;
        ws.refreshState(force: true);
      }
    }
    return true;
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
