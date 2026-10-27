part of '../../core.dart';

enum BlockExecutionAction {
  none,
  query,
  clearItems,
  deleteItem,
  deleteItems,
  quickItemUpdate,
  quickItemCreation,
  backendAction,
}

class BlockNextUnitInput {
  final BlockDataState dataState;
  final BlockExecutionIntent? currentIntent;
  final QueryHint queryHint;
  final bool isVisible;
  final bool queried;
  final String modelName;

  const BlockNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.queryHint,
    required this.isVisible,
    required this.queried,
    required this.modelName,
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
