part of '../core.dart';

class _TaskUiComponents extends _UiComponents {
  final Task task;

  final Map<_ContextProviderViewState, XState> _taskViewWidgetStates = {};

  _TaskUiComponents({required this.task});

  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ..._taskViewWidgetStates.keys,
    ];
    return list.map((v) => v.faRoute).nonNulls.toList().toSet();
  }

  @override
  bool hasMountedViews() {
    return _taskViewWidgetStates.isNotEmpty;
  }

  /// Checks if any UI view connected to this scalar is actively visible on screen.
  bool hasVisibleViews() {
    final String? componentName = findVisibleView();
    return componentName != null;
  }

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  String? findVisibleView() {
    // 1. Content View (TaskView, TaskSectionView)
    final String? componentName = findVisibleContentView();
    if (componentName != null) {
      return componentName;
    }
    return null;
  }

  /// Locates the class name of the actively visible content view for diagnostics.
  String? findVisibleContentView() {
    return findVisibleContentViewWithContextKind(
      contextKind: null,
    );
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in _taskViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          _taskViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addTaskContentWidgetState({
    required _ContextProviderViewState widgetState,
    required final bool isVisible,
  }) {
    final bool isVisibleOld =
        _taskViewWidgetStates[widgetState]?.isVisible ?? false;

    _taskViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    if (!isVisibleOld && isVisible) {
      // LOGIC: #0000
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addActivity(task.activity);
    }
    if (isVisible) {
      FlutterArtist.desk._addRecentActivity(task.activity);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeTaskContentWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    _taskViewWidgetStates.remove(widgetState);
  }
}
