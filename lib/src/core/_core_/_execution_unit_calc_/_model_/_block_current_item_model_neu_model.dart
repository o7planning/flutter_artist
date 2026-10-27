part of '../../core.dart';

enum BlockCurrentItemExecutionAction {
  none,
  setCurrentItem,
  clearCurrentItem,
  prepareFormToCreate,
}

class BlockCurrentItemNextUnitInput {
  final BlockItemDataState dataState;
  final BlockCurrentItemModelExecutionIntent? currentIntent;
  final bool isVisible;
  final bool forceReloadCurrItem;
  final String modelName;
  final BlockFormMode formMode;

  const BlockCurrentItemNextUnitInput({
    required this.dataState,
    required this.formMode,
    required this.currentIntent,
    required this.isVisible,
    required this.forceReloadCurrItem,
    required this.modelName,
  });
}

class BlockCurrentItemNextUnitOutput {
  final BlockCurrentItemExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const BlockCurrentItemNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
