part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and hierarchical
/// view rebuild cascades across all stages contained within a [Prozess].
///
/// Functions as the process container coordinator orchestrating reactive updates downward
/// to individual stages and their associated form views and control bars.
class _ProzessUiComponents extends _UiComponents {
  /// The owner prozess bound to this UI coordinator.
  final Prozess prozess;

  // Registered views: ProzessStageSwitchView, etc.
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};
  // Registered views: ProzessControlBar widget states.
  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};

  _ProzessUiComponents({required this.prozess});

  // *****************************************************************==========
  // *****************************************************************==========

  /// Aggregates all navigation route keys declared across registered prozess content views,
  /// control bars, and all internal stages.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__controlBarWidgetStates.keys,
    ];
    final Set<FaRouteData> set = list
        .map((v) => v.faRoute)
        .nonNulls
        .toList()
        .toSet();

    // Cascade down to all registered stages
    for (final Stage stage in prozess.orderedStages) {
      set.addAll(stage.ui.faRouteDatas);
    }

    return set;
  }

  // *****************************************************************==========
  // *****************************************************************==========

  /// Checks whether any UI component inside this prozess (or its stages) is currently mounted.
  @override
  bool hasMountedViews() {
    if (__contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty) {
      return true;
    }
    for (final Stage stage in prozess.orderedStages) {
      if (stage.ui.hasMountedViews()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI view inside this prozess is actively visible on screen.
  bool hasVisibleViews({bool includeDescendants = true}) {
    final String? componentName = findVisibleView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  String? findVisibleView({bool includeDescendants = true}) {
    // 1. Content View (ProzessStageSwitchView)
    final String? componentName = findVisibleContentView(
      includeDescendants: false,
    );
    if (componentName != null) {
      return componentName;
    }

    // 2. ControlBar
    if (hasVisibleControlBar()) {
      return "ProzessControlBar";
    }

    // 3. Child Stages
    if (includeDescendants) {
      for (final Stage stage in prozess.orderedStages) {
        final String? stageComponentName = stage.ui.findVisibleView();
        if (stageComponentName != null) {
          return stageComponentName;
        }
      }
    }

    return null;
  }

  // *****************************************************************==========
  // *****************************************************************==========

  /// Checks if any content view (e.g. ProzessStageSwitchView) is actively visible on screen.
  bool hasVisibleContentView({bool includeDescendants = true}) {
    final String? componentName = findVisibleContentView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Locates the class name of the actively visible content view for diagnostics.
  String? findVisibleContentView({bool includeDescendants = true}) {
    return findVisibleContentViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = true,
  }) {
    for (final _ContextProviderViewState widgetState
    in __contentViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __contentViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    if (includeDescendants) {
      for (final Stage stage in prozess.orderedStages) {
        final String? stageComponentName =
        stage.ui.findVisibleContentViewWithContextKind(
          contextKind: contextKind,
        );
        if (stageComponentName != null) {
          return stageComponentName;
        }
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether an active [ProzessControlBar] is currently visible on screen.
  bool hasVisibleControlBar() {
    return hasVisibleControlBarWithContextKind(
      contextKind: null,
    );
  }

  /// Checks whether a [ProzessControlBar] matching [contextKind] is currently visible.
  bool hasVisibleControlBarWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
    in __controlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __controlBarWidgetStates[widgetState]?.isVisible ?? false;
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

  /// Resolves the class name of the view currently demanding the Prozess data context.
  String? findVisibleProzessContextView({
    bool includeDescendants = true,
  }) {
    return __findVisibleViewWithContextKind(
      contextKind: ContextKind.prozessInitData,
      includeDescendants: includeDescendants,
    );
  }

  /// Evaluates whether any active UI representation demands this Prozess's data context.
  bool hasProzessContext({
    bool includeDescendants = true,
  }) {
    final String? componentName = findVisibleProzessContextView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = true,
  }) {
    // 1. Prozess Content Views:
    final String? componentName = findVisibleContentViewWithContextKind(
      contextKind: contextKind,
      includeDescendants: false,
    );
    if (componentName != null) {
      return componentName;
    }

    // 2. ControlBar:
    if (hasVisibleControlBarWithContextKind(contextKind: contextKind)) {
      return "ProzessControlBar";
    }

    // 3. Child Stages:
    if (includeDescendants) {
      for (final Stage stage in prozess.orderedStages) {
        final childComponentName =
        stage.ui.__findVisibleViewWithContextKind(
          contextKind: contextKind,
        );
        if (childComponentName != null) {
          return childComponentName;
        }
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Cascades a rebuild request to all mounted views within this prozess (content views, control bars, and stages).
  void refreshAllViews({
    required bool withStages,
    bool force = true,
  }) {
    if (withStages) {
      for (final Stage stage in prozess.orderedStages) {
        stage.ui.refreshAllViews(force: force);
      }
    }
    refreshControlBars(force: force);
    refreshContentViews(force: force);
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

  /// Rebuilds all mounted primary content views (ProzessStageSwitchView).
  void refreshContentViews({bool force = true}) {
    for (final _ContextProviderViewState state
    in __contentViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool prozessContextOld = hasProzessContext(
      includeDescendants: true,
    );
    __controlBarWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    final bool prozessContextCurrent = hasProzessContext(
      includeDescendants: true,
    );

    if (isVisible) {
      FlutterArtist._addRecentModule(prozess.activity);
    }

    if (!prozessContextOld && prozessContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(prozess.activity);
    } else if (prozessContextOld && !prozessContextCurrent) {
      prozess._broadcastProzessHidden();
    }
  }

  void _removeControlBarWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __controlBarWidgetStates.remove(widgetState);
  }

  void _addProzessContentViewWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool prozessContextOld = hasProzessContext(includeDescendants: true);

    __contentViewWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool prozessContextCurrent =
    hasProzessContext(includeDescendants: true);

    if (isVisible) {
      FlutterArtist._addRecentModule(prozess.activity);
    }

    if (!prozessContextOld && prozessContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(prozess.activity);
    } else if (prozessContextOld && !prozessContextCurrent) {
      prozess._broadcastProzessHidden();
    }
  }

  void _removeProzessContentViewWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __contentViewWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();

    if (visibleOld && !visibleCurrent) {
      prozess._broadcastProzessHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedContentViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __contentViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_ContextProviderViewState, XState> _findMountedControlBarWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __controlBarWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withProzessContentView,
    required bool withProzessControlBar,
    required bool withStages,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    if (withProzessContentView) {
      ret.addAll(
        _findMountedContentViewWidgetStates(activeOnly: activeOnly),
      );
    }

    if (withProzessControlBar) {
      ret.addAll(
        _findMountedControlBarWidgetStates(activeOnly: activeOnly),
      );
    }

    if (withStages) {
      for (final Stage stage in prozess.orderedStages) {
        ret.addAll(
          stage.ui._findMountedWidgetStates(
            withStageContentView: true,
            withForm: true,
            withStageControlBar: true,
            activeOnly: activeOnly,
          ),
        );
      }
    }

    return ret;
  }

  @override
  Map<IContextProviderViewState, XState> _debugFindAllMountedWidgetStates() {
    return _debugFindMountedWidgetStates(
      withProzessContentView: true,
      withProzessControlBar: true,
      withStages: true,
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> _debugFindMountedWidgetStates({
    required bool withProzessContentView,
    required bool withProzessControlBar,
    required bool withStages,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withProzessContentView: withProzessContentView,
      withProzessControlBar: withProzessControlBar,
      withStages: withStages,
      activeOnly: activeOnly,
    );
  }
}