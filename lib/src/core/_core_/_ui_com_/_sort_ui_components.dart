part of '../core.dart';

class _SortUIComponents extends _UIComponents {
  final SortModel sortModel;

  final Map<_RefreshableWidgetState, XState> _sortFragmentWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _SortUIComponents({required this.sortModel});

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
    return hasActiveUIComponentWithRepresentativeType(
      representativeType: null,
    );
  }

  bool hasActiveUIComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
  }) {
    for (_RefreshableWidgetState widgetState
        in _sortFragmentWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = _sortFragmentWidgetStates[widgetState]?.isShowing ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isRepresentativeType(representativeType);
      if (ok) {
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

  void _setSortPanelBuildingState({
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
      FlutterArtist.storage._addRecentShelf(sortModel.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      sortModel.shelf._startLoadDataForLazyUIComponentsIfNeed();
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
