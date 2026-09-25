part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [SortModel].
///
/// Serves as the runtime bridge between reactive sort panels (e.g., [SortPanel],
/// [_SortPanelBuilder]) and the underlying sort state.
class _SortUiComponents extends _UiComponents {
  /// The owner sort model bound to this UI coordinator.
  final SortModel sortModel;

  // Registered views: SortPanel / _SortPanelBuilder widget states.
  final Map<_ContextProviderViewState, XState> _sortPanelWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _SortUiComponents({required this.sortModel});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered sort views.
  @override
  Set<FaRouteData> get faRouteDatas {
    return _sortPanelWidgetStates.keys
        .map((v) => v.faRoute)
        .nonNulls
        .toList()
        .toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Locates the class name of the actively visible SortPanel for diagnostic inspection.
  String? findVisibleSortPanel() {
    for (final widgetState in _sortPanelWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final visible = _sortPanelWidgetStates[widgetState]?.isVisible ?? false;
      if (visible) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  /// Diagnostic inspection alias resolving the visible sort view.
  String? findVisibleView() => findVisibleSortPanel();

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _findMountedBaseViewWidgetStates
  Map<_ContextProviderViewState, XState> _findMountedSortPanelWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _sortPanelWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any SortPanel connected to this sort model is mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return _sortPanelWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any SortPanel connected to this model is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    return hasVisibleViewsWithContextKind(
      contextKind: null,
    );
  }

  /// Checks if any SortPanel matching the specified [contextKind] is currently visible.
  // OLD: hasActiveUiComponentWithContextKind
  bool hasVisibleViewsWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in _sortPanelWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          _sortPanelWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted view representations associated with this sort model.
  // OLD: updateAllUiComponents
  void refreshAllViews({bool force = true}) {
    refreshSortPanels(force: force);
  }

  /// Rebuilds specifically the sort panel widgets.
  void refreshSortPanels({bool force = true}) {
    for (final widgetState in [..._sortPanelWidgetStates.keys]) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({
    required _ContextProviderViewState widgetState,
  }) {
    return _sortPanelWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (final XState xState in _sortPanelWidgetStates.values) {
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
    _sortPanelWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _addSortFragmentWidgetState
  void _addSortPanelWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool visibleOld = hasVisibleViews();
    _sortPanelWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    final bool visibleCurrent = hasVisibleViews();

    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(sortModel.shelf);
    }

    if (!visibleOld && visibleCurrent) {
      // LOGIC: #0000
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addShelf(sortModel.shelf);
    } else if (visibleOld && !visibleCurrent) {
      // TODO: Broadcast hidden if needed
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _removeSortFragmentWidgetState
  void _removeSortPanelWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    _sortPanelWidgetStates.remove(widgetState);
  }
}
