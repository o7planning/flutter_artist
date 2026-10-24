part of '../../core.dart';

enum TaskFormExecutionAction {
  none,
  loadData,
  viewChange,
  patchFormFields,
}

class TaskFormNextUnitInput {
  final FormDataState dataState;
  final FormModelExecutionIntent? currentIntent;
  final FormLoadHint formLoadHint;
  final bool isVisible;
  final bool isTaskStateReady;
  final TaskDataState taskDataState;
  final String taskName;

  const TaskFormNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.formLoadHint,
    required this.isVisible,
    required this.isTaskStateReady,
    required this.taskDataState,
    required this.taskName,
  });
}

class TaskFormNextUnitOutput {
  final TaskFormExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const TaskFormNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
