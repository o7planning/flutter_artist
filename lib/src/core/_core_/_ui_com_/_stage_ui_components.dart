part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [Stage].
///
/// Serves as the runtime bridge between reactive stage views ([StageView], [StageControlBar]),
/// optional stage form models, and the execution engine.
class _StageUiComponents extends _WorkNodeUiComponents {
  /// The owner stage bound to this UI coordinator.
  final Stage stage;

  _StageUiComponents({required this.stage});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered stage views and form models.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__controlBarWidgetStates.keys,
    ];
    final Set<FaRouteData> faRoutes =
        list.map((v) => v.faRoute).nonNulls.toList().toSet();
    if (stage.formModel != null) {
      faRoutes.addAll(stage.formModel!.ui.faRouteDatas);
    }
    return faRoutes;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withStageContentView,
    required bool withForm,
    required bool withStageControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    if (withStageContentView) {
      ret.addAll(
        ___findMountedWidgetStates(
          widgetStates: __contentViewWidgetStates,
          activeOnly: activeOnly,
        ),
      );
    }

    if (withStageControlBar) {
      ret.addAll(
        ___findMountedWidgetStates(
          widgetStates: __controlBarWidgetStates,
          activeOnly: activeOnly,
        ),
      );
    }

    if (withForm && stage.formModel != null) {
      ret.addAll(
        stage.formModel!.ui._findMountedFormWidgetStates(
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
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withStageContentView,
    required bool withForm,
    required bool withStageControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withStageContentView: withStageContentView,
      withForm: withForm,
      withStageControlBar: withStageControlBar,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component connected to this stage is currently mounted in the widget tree.
  @override
  bool hasMountedViews() {
    return __contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty ||
        (stage.formModel?.ui.hasMountedViews() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether any active UI representation demands this Stage's context.
  bool hasStageContext({bool includeDescendants = false}) {
    return findVisibleStageContextView() != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  @override
  String? findVisibleView() {
    // 1. Content View (StageView)
    final String? componentName = findVisibleContentView();
    if (componentName != null) {
      return componentName;
    }

    // 2. ControlBar
    if (hasVisibleControlBar()) {
      return "StageControlBar";
    }

    // 3. Form
    if (stage.formModel != null && stage.formModel!.ui.hasVisibleViews()) {
      return getClassNameWithoutGenerics(stage.formModel);
    }

    return null;
  }

  /// Resolves the class name of the view currently demanding the Stage data context.
  String? findVisibleStageContextView() {
    return __findVisibleViewWithContextKind(contextKind: ContextKind.stage);
  }

  @override
  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    // 1. Form
    if (stage.formModel != null) {
      final bool has = stage.formModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(stage.formModel);
      }
    }

    // 2. Stage Content Views
    final String? componentName = findVisibleContentViewWithContextKind(
      contextKind: contextKind,
    );
    if (componentName != null) {
      return componentName;
    }

    // 3. ControlBar
    if (hasVisibleControlBarWithContextKind(contextKind: contextKind)) {
      return "StageControlBar";
    }

    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted views connected to this stage and its form model.
  @override
  void refreshAllViews({bool force = true}) {
    refreshControlBars(force: force);
    refreshContentViews(force: force);
    stage.formModel?.ui.refreshAllViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool stageContextOld = hasStageContext();

    __controlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool stageContextCurrent = hasStageContext();

    if (isVisible) {
      FlutterArtist._addRecentModule(stage.activity);
    }

    if (!stageContextOld && stageContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(stage.activity);
    } else if (stageContextOld && !stageContextCurrent) {
      stage._broadcastStageHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addStageBaseViewWidgetState({
    required _StageViewBuilderState widgetState,
    required final bool isVisible,
  }) {
    final bool stageContextOld = hasStageContext();

    __contentViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool stageContextCurrent = hasStageContext();

    if (isVisible) {
      FlutterArtist._addRecentModule(stage.activity);
    }

    if (!stageContextOld && stageContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(stage.activity);
    } else if (stageContextOld && !stageContextCurrent) {
      stage._broadcastStageHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeStageBaseViewWidgetState({
    required _StageViewBuilderState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __contentViewWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();

    if (visibleOld && !visibleCurrent) {
      stage._broadcastStageHidden();
    }
  }
}
