part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and hierarchical
/// view rebuild cascades across all stages contained within a [Prozess].
///
/// Functions as the process container coordinator orchestrating reactive updates downward
/// to individual stages and their associated form views and control bars.
class _ProzessUiComponents extends _UiComponents {
  /// The owner prozess bound to this UI coordinator.
  final Prozess prozess;

  // Registered views: ProzessControlBar widget states.
  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};

  _ProzessUiComponents({required this.prozess});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered prozess control bars
  /// and all internal stages.
  @override
  Set<FaRouteData> get faRouteDatas {
    final Set<FaRouteData> set = {};

    // 1. Routes from ProzessControlBars
    for (final _ContextProviderViewState state
        in __controlBarWidgetStates.keys) {
      final route = state.faRoute;
      if (route != null) {
        set.add(route);
      }
    }

    // 2. Cascade down to all registered stages
    for (final Stage stage in prozess.stages) {
      set.addAll(stage.ui.faRouteDatas);
    }

    return set;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withStageContentView,
    required bool withForm,
    required bool withStageControlBar,
    required bool withProzessControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    // 1. Collect Prozess control bar states
    if (withProzessControlBar) {
      ret.addAll(
        ___findMountedWidgetStates(
          widgetStates: __controlBarWidgetStates,
          activeOnly: activeOnly,
        ),
      );
    }

    // 2. Cascade down to all stages within this Prozess
    for (final Stage stage in prozess.stages) {
      ret.addAll(
        stage.ui._findMountedWidgetStates(
          withStageContentView: withStageContentView,
          withForm: withForm,
          withStageControlBar: withStageControlBar,
          activeOnly: activeOnly,
        ),
      );
    }

    return ret;
  }

  @override
  Map<IContextProviderViewState, XState> debugFindAllMountedWidgetStates() {
    return debugFindMountedWidgetStates(
      withStageContentView: true,
      withForm: true,
      withStageControlBar: true,
      withProzessControlBar: true,
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withStageContentView,
    required bool withForm,
    required bool withStageControlBar,
    required bool withProzessControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withStageContentView: withStageContentView,
      withForm: withForm,
      withStageControlBar: withStageControlBar,
      withProzessControlBar: withProzessControlBar,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component inside this prozess (or its stages) is currently mounted.
  @override
  bool hasMountedViews() {
    if (__controlBarWidgetStates.isNotEmpty) {
      return true;
    }
    for (final Stage stage in prozess.stages) {
      if (stage.ui.hasMountedViews()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI view inside this prozess is actively visible on screen.
  bool hasVisibleViews() {
    return findVisibleView() != null;
  }

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  String? findVisibleView() {
    // 1. ControlBar
    if (hasVisibleControlBar()) {
      return "ProzessControlBar";
    }

    // 2. Cascade check across all stages
    for (final Stage stage in prozess.stages) {
      final String? componentName = stage.ui.findVisibleView();
      if (componentName != null) {
        return componentName;
      }
    }

    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether an active [ProzessControlBar] is currently visible on screen.
  bool hasVisibleControlBar() {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          __controlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (visible) return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Cascades a rebuild request to all mounted views within this prozess (control bars and stages).
  void refreshAllViews({bool force = true}) {
    refreshControlBars(force: force);
    for (final Stage stage in prozess.stages) {
      stage.ui.refreshAllViews(force: force);
    }
  }

  /// Rebuilds active prozess control bars.
  void refreshControlBars({bool force = false}) {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _ProzessControlBarState widgetState,
    required bool isVisible,
  }) {
    final bool visibleOld = hasVisibleViews();

    __controlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool visibleCurrent = hasVisibleViews();

    if (isVisible) {
      FlutterArtist._addRecentModule(prozess.activity);
    }

    if (!visibleOld && visibleCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(prozess.activity);
    } else if (visibleOld && !visibleCurrent) {
      prozess._broadcastProzessHidden();
    }
  }

  void _removeControlBarWidgetState({
    required _ProzessControlBarState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __controlBarWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();

    if (visibleOld && !visibleCurrent) {
      prozess._broadcastProzessHidden();
    }
  }
}
