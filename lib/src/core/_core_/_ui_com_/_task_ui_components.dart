part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [Task].
///
/// Serves as the runtime bridge between reactive task views ([TaskView], [TaskControlBar]),
/// optional form models, and the task execution engine.
class _TaskUiComponents extends _WorkNodeUiComponents {
  /// The owner task bound to this UI coordinator.
  final Task task;

  _TaskUiComponents({required this.task});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered task views and form models.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__controlBarWidgetStates.keys,
    ];
    final Set<FaRouteData> faRoutes =
        list.map((v) => v.faRoute).nonNulls.toList().toSet();
    if (task.formModel != null) {
      faRoutes.addAll(task.formModel!.ui.faRouteDatas);
    }
    return faRoutes;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withTaskContentView,
    required bool withForm,
    required bool withTaskControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    if (withTaskContentView) {
      ret.addAll(
        ___findMountedWidgetStates(
          widgetStates: __contentViewWidgetStates,
          activeOnly: activeOnly,
        ),
      );
    }

    if (withTaskControlBar) {
      ret.addAll(
        ___findMountedWidgetStates(
          widgetStates: __controlBarWidgetStates,
          activeOnly: activeOnly,
        ),
      );
    }

    if (withForm && task.formModel != null) {
      ret.addAll(
        task.formModel!.ui._findMountedFormWidgetStates(
          activeOnly: activeOnly,
        ),
      );
    }

    return ret;
  }

  @override
  Map<IContextProviderViewState, XState> _debugFindAllMountedWidgetStates() {
    return _debugFindMountedWidgetStates(
      withTaskContentView: true,
      withForm: true,
      withTaskControlBar: true,
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> _debugFindMountedWidgetStates({
    required bool withTaskContentView,
    required bool withForm,
    required bool withTaskControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withTaskContentView: withTaskContentView,
      withForm: withForm,
      withTaskControlBar: withTaskControlBar,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component connected to this task (or its form) is currently mounted.
  @override
  bool hasMountedViews() {
    return __contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty ||
        (task.formModel?.ui.hasMountedViews() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether any active UI representation demands this Task's data context.
  bool hasTaskContext() {
    return findVisibleTaskContextView() != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  @override
  String? findVisibleView() {
    // 1. Content View (TaskView)
    final String? componentName = findVisibleContentView();
    if (componentName != null) {
      return componentName;
    }

    // 2. ControlBar
    if (hasVisibleControlBar()) {
      return "TaskControlBar";
    }

    // 3. Form
    if (task.formModel != null && task.formModel!.ui.hasVisibleViews()) {
      return getClassNameWithoutGenerics(task.formModel);
    }

    return null;
  }

  /// Resolves the class name of the view currently demanding the Task data context.
  String? findVisibleTaskContextView() {
    return __findVisibleViewWithContextKind(contextKind: ContextKind.task);
  }

  @override
  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    // 1. Form
    if (task.formModel != null) {
      final bool has = task.formModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(task.formModel);
      }
    }

    // 2. Task Content Views
    final String? componentName = findVisibleContentViewWithContextKind(
      contextKind: contextKind,
    );
    if (componentName != null) {
      return componentName;
    }

    // 3. ControlBar
    if (hasVisibleControlBarWithContextKind(contextKind: contextKind)) {
      return "TaskControlBar";
    }

    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted views connected to this task and its form model.
  @override
  void refreshAllViews({bool force = true}) {
    refreshControlBars(force: force);
    refreshContentViews(force: force);
    task.formModel?.ui.refreshAllViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool taskContextOld = hasTaskContext();

    __controlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool taskContextCurrent = hasTaskContext();

    if (isVisible) {
      FlutterArtist._addRecentModule(task.activity);
    }

    if (!taskContextOld && taskContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(task.activity);
    } else if (taskContextOld && !taskContextCurrent) {
      task._broadcastTaskHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addTaskContentWidgetState({
    required _ContextProviderViewState widgetState,
    required final bool isVisible,
  }) {
    final bool taskContextOld = hasTaskContext();

    __contentViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool taskContextCurrent = hasTaskContext();

    if (isVisible) {
      FlutterArtist._addRecentModule(task.activity);
    }

    if (!taskContextOld && taskContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(task.activity);
    } else if (taskContextOld && !taskContextCurrent) {
      task._broadcastTaskHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeTaskContentWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __contentViewWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();

    if (visibleOld && !visibleCurrent) {
      task._broadcastTaskHidden();
    }
  }
}
