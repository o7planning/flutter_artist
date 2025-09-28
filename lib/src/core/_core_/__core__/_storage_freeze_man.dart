part of '../core.dart';

class _StorageFreezeMan {
  final _Storage storage;

  final Map<_RefreshableWidgetState, bool> _freezingAgentWidgetStateMap = {};

  _StorageFreezeMan(this.storage);

  bool get isFreezing {
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
      _recheckFreezingState();
    }
  }

  void _onWidgetStateDisposed({
    required _RefreshableWidgetState widgetState,
  }) {
    if (_freezingAgentWidgetStateMap.containsKey(widgetState)) {
      _freezingAgentWidgetStateMap.remove(widgetState);
      _recheckFreezingState();
    }
  }

  ///
  /// Check to execute delayed reaction.
  ///
  Future<void> _recheckFreezingState() async {
    if (isFreezing) {
      return;
    }
    // SAME-AS: #0003
    for (String shelfName in storage._shelfMap.keys) {
      Shelf reactionShelf = storage._shelfMap[shelfName]!;
      if (reactionShelf._hasReactionBookmark()) {
        reactionShelf._addShelfExternalReactionTaskUnit();
      }
    }
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  bool createFreezingAgentWidgetState({
    required List<Shelf> shelves,
    required bool findBlockFragment,
    required bool findForm,
    required bool findScalarFragment,
  }) {
    if (isFreezing) {
      return false;
    }
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
      return false;
    }
    _freezingAgentWidgetStateMap
      ..clear()
      ..addAll(
        map.map(
          (k, v) => MapEntry<_RefreshableWidgetState, bool>(k, v.isShowing),
        ),
      );
    return true;
  }
}
