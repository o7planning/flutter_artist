part of '../../core.dart';

enum StageFormExecutionAction {
  none,
  loadData,
  viewChange,
  patchFormFields,
}

class StageFormNextUnitInput {
  final FormDataState dataState;
  final FormModelExecutionIntent? currentIntent;
  final FormLoadHint formLoadHint;
  final bool isVisible;
  final String stageName;

  const StageFormNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.formLoadHint,
    required this.isVisible,
    required this.stageName,
  });
}

class StageFormNextUnitOutput {
  final StageFormExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const StageFormNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
