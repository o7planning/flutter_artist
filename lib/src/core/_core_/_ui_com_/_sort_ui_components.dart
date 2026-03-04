part of '../core.dart';

class _SortUiComponents extends _UiComponents {
  final SortModel sortModel;

  final Map<_ContextProviderViewState, XState> _sortWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _SortUiComponents({required this.sortModel});

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _sortWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return _sortWidgetStates.isNotEmpty;
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
    for (_ContextProviderViewState widgetState in _sortWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = _sortWidgetStates[widgetState]?.isVisible ?? false;
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

  void updateAllUiComponents({bool force = true}) {
    for (_ContextProviderViewState widgetState in [..._sortWidgetStates.keys]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding(
      {required _ContextProviderViewState widgetState}) {
    return _sortWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (XState xState in _sortWidgetStates.values) {
      if (xState.isBuilding) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setSortPanelBuildingState({
    required _ContextProviderViewState widgetState,
    required bool isBuilding,
  }) {
    _sortWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addSortFragmentWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _sortWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool activeCURRENT = hasActiveUiComponent();

    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(sortModel.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      // sortModel.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(sortModel.shelf);
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._emitBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeSortFragmentWidgetState({
    required State widgetState,
  }) {
    _sortWidgetStates.remove(widgetState);
  }
}
