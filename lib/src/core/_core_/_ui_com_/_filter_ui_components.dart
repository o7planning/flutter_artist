part of '../core.dart';

class _FilterUIComponents extends _UIComponents {
  final FilterModel filterModel;

  final Map<_RefreshableWidgetState, XState> _filterFragmentWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _FilterUIComponents({required this.filterModel});

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedPieceWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _filterFragmentWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return _filterFragmentWidgetStates.isNotEmpty;
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
        in _filterFragmentWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          _filterFragmentWidgetStates[widgetState]?.isShowing ?? false;
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
      ..._filterFragmentWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _filterFragmentWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (XState xState in _filterFragmentWidgetStates.values) {
      if (xState.isBuilding) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterPanelBuildingState({
    required _RefreshableWidgetState widgetState,
    required bool isBuilding,
  }) {
    _filterFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFilterFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _filterFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();

    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(filterModel.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      // filterModel.shelf._startLoadDataForLazyUIComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(filterModel.shelf);
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFilterFragmentWidgetState({
    required State widgetState,
  }) {
    _filterFragmentWidgetStates.remove(widgetState);
  }
}
