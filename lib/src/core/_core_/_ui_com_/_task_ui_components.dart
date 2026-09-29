part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [Task].
///
/// Serves as the runtime bridge between reactive task views ([TaskView], [TaskControlBar]),
/// optional form models, and the task execution engine.
class _TaskUiComponents extends _UiComponents {
  /// The owner task bound to this UI coordinator.
  final Task task;

  // Registered views: TaskView, TaskSectionView.
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};
  // Registered views: TaskControlBar.
  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};

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

  /// Checks whether any UI component connected to this task (or its form) is currently mounted.
  @override
  bool hasMountedViews() {
    return __contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty ||
        (task.formModel?.ui.hasMountedViews() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any UI view connected to this task is actively visible on screen.
  bool hasVisibleViews() {
    return findVisibleView() != null;
  }

  /// Evaluates whether any active UI representation demands this Task's data context.
  bool hasTaskContext({bool includeDescendants = false}) {
    return findVisibleTaskContextView() != null;
  }

  /// Evaluates whether an active Form representation demands task-level form context.
  bool hasFormContext() {
    return findVisibleFormContextView() != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Resolves the class name of any actively visible view for diagnostic inspection.
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

  /// Resolves the class name of the view currently demanding the Form data context.
  String? findVisibleFormContextView() {
    return __findVisibleViewWithContextKind(contextKind: ContextKind.form);
  }

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

  /// Checks if any content view (e.g. TaskView) is actively visible on screen.
  bool hasVisibleContentView() {
    return findVisibleContentView() != null;
  }

  /// Locates the class name of the actively visible content view.
  String? findVisibleContentView() {
    return findVisibleContentViewWithContextKind(contextKind: null);
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in __contentViewWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          __contentViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) continue;
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether an active [TaskControlBar] is currently visible on screen.
  bool hasVisibleControlBar() {
    return hasVisibleControlBarWithContextKind(contextKind: null);
  }

  /// Checks whether a [TaskControlBar] matching [contextKind] is currently visible.
  bool hasVisibleControlBarWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          __controlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) continue;
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds active task control bars.
  void refreshControlBars({bool force = false}) {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  /// Rebuilds mounted primary content views (TaskView).
  void refreshContentViews({bool force = true}) {
    for (final _ContextProviderViewState state
        in __contentViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  /// Rebuilds all mounted views connected to this task and its form model.
  void refreshAllViews({bool force = true}) {
    refreshControlBars(force: force);
    refreshContentViews(force: force);
    task.formModel?.ui.refreshAllViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

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
      FlutterArtist.desk._addRecentActivity(task.activity);
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

  void _removeControlBarWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __controlBarWidgetStates.remove(widgetState);
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
      FlutterArtist.desk._addRecentActivity(task.activity);
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
