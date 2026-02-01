part of '../core.dart';

class ActivityConfig {
  final ActivityHiddenAction onHideAction;

  const ActivityConfig({
    this.onHideAction = ActivityHiddenAction.none,
  });

  ActivityConfig copy() {
    return ActivityConfig(onHideAction: onHideAction);
  }
}
