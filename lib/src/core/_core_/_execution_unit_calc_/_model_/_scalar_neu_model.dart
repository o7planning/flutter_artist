part of '../../core.dart';

enum ScalarExecutionAction {
  none,
  query,
  loadExtraData,
  clear,
}

class ScalarNextUnitInput {
  final ScalarDataState dataState;
  final ScalarExecutionIntent? currentIntent;
  final QueryHint queryHint;
  final bool isVisible;
  final bool queried;
  final String modelName;

  const ScalarNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.queryHint,
    required this.isVisible,
    required this.queried,
    required this.modelName,
  });
}

class ScalarNextUnitOutput {
  final ScalarExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const ScalarNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
