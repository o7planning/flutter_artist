part of '../../core.dart';

enum TaskExecutionAction {
  none,
  restart,
  submit,
}

class TaskNextUnitInput {
  final TaskDataState dataState;
  final TaskBaseExecutionIntent? currentIntent;
  final ExecHint execHint;
  final bool isVisible;
  final bool executed;
  final String modelName;

  const TaskNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.execHint,
    required this.isVisible,
    required this.executed,
    required this.modelName,
  });
}

class TaskNextUnitOutput {
  final TaskExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const TaskNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
