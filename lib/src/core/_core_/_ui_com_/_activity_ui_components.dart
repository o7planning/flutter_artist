part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and hierarchical
/// view rebuild cascades across all data models contained within an [Activity].
///
/// Functions as the top-level activity coordinator orchestrating reactive updates downward
/// to tasks and prozesses.
class _ActivityUiComponents extends _ModuleUiComponents {
  /// The owner activity bound to this UI coordinator.
  final Activity activity;

  // ***************************************************************************
  // ***************************************************************************

  _ActivityUiComponents({required this.activity});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across all tasks and prozesses in this activity.
  @override
  Set<FaRouteData> get faRouteDatas {
    final Set<FaRouteData> set = {};
    for (final Task task in activity.tasks) {
      set.addAll(task.ui.faRouteDatas);
    }
    for (final Prozess prozess in activity.prozesses) {
      set.addAll(prozess.ui.faRouteDatas);
    }
    return set;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component inside this activity is actively visible on screen.
  bool hasVisibleViews() {
    for (final Task task in activity.tasks) {
      if (task.ui.hasVisibleViews()) {
        return true;
      }
    }
    for (final Prozess prozess in activity.prozesses) {
      if (prozess.ui.hasVisibleViews()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component inside this activity is currently mounted in the widget tree.
  @override
  bool hasMountedViews() {
    for (final Task task in activity.tasks) {
      if (task.ui.hasMountedViews()) {
        return true;
      }
    }
    for (final Prozess prozess in activity.prozesses) {
      if (prozess.ui.hasMountedViews()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withTask,
    required bool withProzess,
    required bool withProzessControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    if (withTask) {
      for (final Task task in activity.tasks) {
        ret.addAll(
          task.ui._findMountedWidgetStates(
            withTaskContentView: true,
            withForm: true,
            withTaskControlBar: true,
            activeOnly: activeOnly,
          ),
        );
      }
    }

    if (withProzess) {
      for (final Prozess prozess in activity.prozesses) {
        ret.addAll(
          prozess.ui._findMountedWidgetStates(
            withStageContentView: true,
            withForm: true,
            withStageControlBar: true,
            withProzessControlBar: withProzessControlBar,
            activeOnly: activeOnly,
          ),
        );
      }
    }

    return ret;
  }

  @override
  Map<IContextProviderViewState, XState> debugFindAllMountedWidgetStates() {
    return debugFindMountedWidgetStates(
      withTask: true,
      withProzess: true,
      withProzessControlBar: true,
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withTask,
    required bool withProzess,
    required bool withProzessControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withTask: withTask,
      withProzess: withProzess,
      withProzessControlBar: withProzessControlBar,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Cascades a rebuild request to all mounted views within this activity (tasks and prozesses).
  @override
  void refreshAllViews() {
    try {
      print("|----> ${getClassName(activity)}.ui.refreshAllViews()");
      //
      for (final Task task in activity.tasks) {
        task.ui.refreshAllViews();
      }
      //
      for (final Prozess prozess in activity.prozesses) {
        prozess.ui.refreshAllViews();
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }
}
