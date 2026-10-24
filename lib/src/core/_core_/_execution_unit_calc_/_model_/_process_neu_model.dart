part of '../../core.dart';

enum ProzessExecutionAction {
  none,
  restart,
  determineNextStage,
}

class ProzessNextUnitInput {
  final ProzessDataState dataState;
  final ProzessExecutionIntent? currentIntent;
  final ExecHint restartHint;
  final bool isVisible;
  final bool initDataLoaded;
  final String modelName;

  const ProzessNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.restartHint,
    required this.isVisible,
    required this.initDataLoaded,
    required this.modelName,
  });
}

class ProzessNextUnitOutput {
  final ProzessExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const ProzessNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}