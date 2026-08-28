part of '../../core.dart';

class TaskConfig {
  const TaskConfig();

  TaskConfig copy() => const TaskConfig();
}

class TaskEffectiveConfig {
  final TaskConfig _baselineConfig;

  TaskEffectiveConfig._fromConfig(this._baselineConfig);

  factory TaskEffectiveConfig.fromConfig(TaskConfig config) =>
      TaskEffectiveConfig._fromConfig(config);
}
