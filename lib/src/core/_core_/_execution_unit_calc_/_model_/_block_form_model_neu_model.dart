part of '../../core.dart';

enum BlockFormExecutionAction {
  none,
  loadData,
  viewChange,
  save,
  patchFormFields,
}

class BlockFormNextUnitInput {
  final FormDataState dataState;
  final FormModelExecutionIntent? currentIntent;
  final FormLoadHint formLoadHint;
  final bool isVisible;
  final BlockFormMode formMode;
  final String blockName;

  const BlockFormNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.formLoadHint,
    required this.isVisible,
    required this.formMode,
    required this.blockName,
  });
}

class BlockFormNextUnitOutput {
  final BlockFormExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const BlockFormNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
