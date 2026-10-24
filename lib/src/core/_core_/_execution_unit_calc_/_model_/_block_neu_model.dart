part of '../../core.dart';

enum BlockExecutionAction {
  none,
  query,
  setCurrentItem,
  clearCurrentItem,
  deleteItem,
  deleteItems,
  prepareFormToCreate,
  quickItemUpdate,
  quickItemCreation,
  backendAction,
}

class BlockNextUnitInput {
  final BlockDataState dataState;
  final BlockItemDataState itemDataState;
  final BlockExecutionIntent? currentIntent;
  final QueryHint queryHint;
  final bool isVisible;
  final bool queried;
  final String modelName;

  // For state 4.3 (Automatic synchronization)
  final bool hasFormModel;
  final BlockFormMode? formMode;
  final int itemCount;
  final bool itemVisibleX;

  const BlockNextUnitInput({
    required this.dataState,
    required this.itemDataState,
    required this.currentIntent,
    required this.queryHint,
    required this.isVisible,
    required this.queried,
    required this.modelName,
    required this.hasFormModel,
    required this.formMode,
    required this.itemCount,
    required this.itemVisibleX,
  });
}

class BlockNextUnitOutput {
  final BlockExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const BlockNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
