part of '../../core.dart';

enum StageExecutionAction {
  none,
  restart,
  submit,
}

class StageNextUnitInput {
  final StageDataState dataState;
  final StageExecutionIntent? currentIntent;
  final ExecHint execHint;
  final bool isVisible;
  final bool executed;
  final String modelName;
  final bool isCurrentStage;
  final String prozessName;

  const StageNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.execHint,
    required this.isVisible,
    required this.executed,
    required this.modelName,
    required this.isCurrentStage,
    required this.prozessName,
  });
}

class StageNextUnitOutput {
  final StageExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const StageNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
