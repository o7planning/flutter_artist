part of '../core.dart';

class _SortUIComponents extends _UIComponents {
  final SortingModel sortingModel;

  final Map<_RefreshableWidgetState, XState> _sortFragmentWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _SortUIComponents({required this.sortingModel});

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedFragmentWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _sortFragmentWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return _sortFragmentWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    for (State widgetState in _sortFragmentWidgetStates.keys) {
      bool isShowing =
          _sortFragmentWidgetStates[widgetState]?.isShowing ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({bool force = true}) {
    for (_RefreshableWidgetState widgetState in [
      ..._sortFragmentWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _sortFragmentWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (XState xState in _sortFragmentWidgetStates.values) {
      if (xState.isBuilding) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setSortViewBuildingState({
    required _RefreshableWidgetState widgetState,
    required bool isBuilding,
  }) {
    _sortFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addSortFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _sortFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();

    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(sortingModel.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      sortingModel.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeSortFragmentWidgetState({
    required State widgetState,
  }) {
    _sortFragmentWidgetStates.remove(widgetState);
  }
}
