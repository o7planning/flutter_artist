part of '../core.dart';

class _FilterUiComponents extends _UiComponents {
  final FilterModel filterModel;

  final Map<_RefreshableWidgetState, XState> _filterBaseViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _FilterUiComponents({required this.filterModel});

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _filterBaseViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return _filterBaseViewWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent() {
    return hasActiveUiComponentWithContextKind(
      contextKind: null,
    );
  }

  bool hasActiveUiComponentWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (_RefreshableWidgetState widgetState
        in _filterBaseViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          _filterBaseViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateFilterBaseViews({bool force = true}) {
    for (_RefreshableWidgetState state in _filterBaseViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents({bool force = true}) {
    for (_RefreshableWidgetState widgetState in [
      ..._filterBaseViewWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return _filterBaseViewWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (XState xState in _filterBaseViewWidgetStates.values) {
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
    _filterBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFilterFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _filterBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool activeCURRENT = hasActiveUiComponent();

    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(filterModel.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      // filterModel.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(filterModel.shelf);
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._emitBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFilterFragmentWidgetState({
    required State widgetState,
  }) {
    _filterBaseViewWidgetStates.remove(widgetState);
  }
}
