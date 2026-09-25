part of '../core.dart';

/// Coordinates UI representations, panel visibility tracking, and view rebuild cycles
/// for an individual [FilterModel].
///
/// Serves as the runtime bridge between reactive filter panel widgets (e.g., [FilterPanel],
/// [FilterControlBar]) and the underlying filter state.
class _FilterUiComponents extends _UiComponents {
  /// The owner filter model bound to this UI coordinator.
  final FilterModel filterModel;

  // Registered views: FilterPanel widgets.
  final Map<_ContextProviderViewState, XState> _filterPanelWidgetStates = {};

  // Registered views: FilterControlBar widgets.
  final Map<_ContextProviderViewState, XState> _controlBarWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _FilterUiComponents({required this.filterModel});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered filter views.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ..._filterPanelWidgetStates.keys,
      ..._controlBarWidgetStates.keys,
    ];
    return list.map((v) => v.faRoute).nonNulls.toList().toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Returns all active Flutter FormBuilderState instances currently mounted in visible filter panels.
  // OLD: _activeFormBuilderStates
  List<FormBuilderState> get _visibleFormBuilderStates {
    final List<FormBuilderState> forms = [];
    for (final _ContextProviderViewState state
        in _filterPanelWidgetStates.keys) {
      if (state.mounted && state is _FilterPanelBuilderState) {
        final formState = state.formKey.currentState;
        if (formState != null) {
          forms.add(formState);
        }
      }
    }
    return forms;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _findMountedBaseViewWidgetStates / _findMountedContentViewWidgetStates
  Map<_ContextProviderViewState, XState> _findMountedFilterPanelWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _filterPanelWidgetStates,
      activeOnly: activeOnly,
    );
  }

  /// Locates the class name of the actively visible FilterPanel for diagnostic inspection.
  String? findVisibleFilterPanel() {
    for (final widgetState in _filterPanelWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          _filterPanelWidgetStates[widgetState]?.isVisible ?? false;
      if (visible) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any filter view (panel or control bar) is currently mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return _filterPanelWidgetStates.isNotEmpty ||
        _controlBarWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any FilterPanel view is actively visible on screen.
  bool hasVisibleFilterPanel() {
    return findVisibleFilterPanel() != null;
  }

  /// Checks if any FilterControlBar is actively visible on screen.
  bool hasVisibleControlBar() {
    for (final widgetState in _controlBarWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          _controlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (visible) return true;
    }
    return false;
  }

  /// Checks if any view connected to this filter model is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    return hasVisibleViewsWithContextKind(
      contextKind: null,
    );
  }

  /// Checks if any filter view matching the specified [contextKind] is currently visible.
  // OLD: hasActiveUiComponentWithContextKind
  bool hasVisibleViewsWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in _filterPanelWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          _filterPanelWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    for (final _ContextProviderViewState widgetState
        in _controlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          _controlBarWidgetStates[widgetState]?.isVisible ?? false;
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

  /// Rebuilds specifically the filter panel form views.
  // OLD: updateFilterBaseViews
  void refreshFilterPanels({bool force = true}) {
    for (final _ContextProviderViewState state
        in _filterPanelWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  /// Rebuilds active filter control bars.
  void refreshControlBars({bool force = false}) {
    for (final _ContextProviderViewState state
        in _controlBarWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted view representations associated with this filter model.
  // OLD: updateAllUiComponents
  void refreshAllViews({bool force = true}) {
    refreshFilterPanels(force: force);
    refreshControlBars(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({
    required _ContextProviderViewState widgetState,
  }) {
    return _filterPanelWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isBuilding() {
    for (final XState xState in _filterPanelWidgetStates.values) {
      if (xState.isBuilding) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFilterPanelBuildingState({
    required _ContextProviderViewState widgetState,
    required bool isBuilding,
  }) {
    _filterPanelWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _addFilterFragmentWidgetState
  void _addFilterPanelWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool visibleOld = hasVisibleViews();
    _filterPanelWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    final bool visibleCurrent = hasVisibleViews();

    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(filterModel.shelf);
    }

    if (!visibleOld && visibleCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addShelf(filterModel.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _removeFilterFragmentWidgetState
  void _removeFilterPanelWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    _filterPanelWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool visibleOld = hasVisibleViews();
    _controlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    final bool visibleCurrent = hasVisibleViews();

    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(filterModel.shelf);
    }

    if (!visibleOld && visibleCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addShelf(filterModel.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlBarWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    _controlBarWidgetStates.remove(widgetState);
  }
}
