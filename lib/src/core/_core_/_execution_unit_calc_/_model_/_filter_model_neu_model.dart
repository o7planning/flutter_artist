part of '../../core.dart';

enum FilterExecutionAction {
  none,
  loadData,
  panelChange,
}

class FilterNextUnitInput {
  final bool loadedInSession;
  final FilterDataState committedDataState;
  final FilterDataState draftDataState;
  final FilterModelExecutionIntent? currentIntent;
  final FilterLoadHint filterLoadHint;
  final String modelName;

  const FilterNextUnitInput({
    required this.loadedInSession,
    required this.committedDataState,
    required this.draftDataState,
    required this.currentIntent,
    required this.filterLoadHint,
    required this.modelName,
  });
}

class FilterNextUnitOutput {
  final FilterExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const FilterNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}
