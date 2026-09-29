part of '../core.dart';

class TaskConfig {
  final ScalarHiddenAction onHideAction;

  const TaskConfig() : onHideAction = ScalarHiddenAction.none;

  TaskConfig copy() => const TaskConfig();
}

class TaskEffectiveConfig {
  final TaskConfig _baselineConfig;

  TaskEffectiveConfig._fromConfig(this._baselineConfig);

  factory TaskEffectiveConfig.fromConfig(TaskConfig config) =>
      TaskEffectiveConfig._fromConfig(config);

  ScalarHiddenAction get onHideAction => _baselineConfig.onHideAction;
}
