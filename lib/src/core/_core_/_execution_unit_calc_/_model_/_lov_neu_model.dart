part of '../../core.dart';

enum LovExecutionAction {
  query,
  clearItems,
  none,
}

class LovNextUnitInput {
  final LovDataState dataState;
  final LovExecutionIntent? currentIntent;
  final QueryHint queryHint;
  final bool isVisible;
  final bool queried;
  final String modelName;

  const LovNextUnitInput({
    required this.dataState,
    required this.currentIntent,
    required this.queryHint,
    required this.isVisible,
    required this.queried,
    required this.modelName,
  });
}

class LovNextUnitOutput {
  final LovExecutionAction action;
  final MissingIntentType? missingIntent;
  final bool preserveCurrentIntent;
  final String debugInfo;

  const LovNextUnitOutput({
    required this.action,
    this.missingIntent,
    this.preserveCurrentIntent = false,
    required this.debugInfo,
  });
}

class LovExecutionCalculator {
  static LovNextUnitOutput calculate(LovNextUnitInput input) {
    final String prefix = "${input.modelName} "
        "[state: ${input.dataState.toBriefInfo()}, "
        "visible: ${input.isVisible}, "
        "queried: ${input.queried}, "
        "queryHint: ${input.queryHint}, "
        "_executionIntent: ${input.currentIntent}]";

    // 1. Explicit ClearItems intent
    if (input.currentIntent is LovClearItemsIntent) {
      return LovNextUnitOutput(
        action: LovExecutionAction.clearItems,
        debugInfo: "$prefix -> clearItems",
      );
    }

    // 2. Explicit Query intent
    if (input.currentIntent is LovQueryIntent) {
      return LovNextUnitOutput(
        action: LovExecutionAction.query,
        debugInfo: "$prefix -> explicit query",
      );
    }

    // 3. Already finished in this session
    if (input.currentIntent is LovDoneIntent) {
      return LovNextUnitOutput(
        action: LovExecutionAction.none,
        debugInfo: "$prefix -> done",
      );
    }

    // 4. Forced query hint (e.g., from FilterModel.query() or LovModel.query())
    if (!input.queried && input.queryHint == QueryHint.force) {
      return LovNextUnitOutput(
        action: LovExecutionAction.query,
        missingIntent: MissingIntentType.dataLoadOrQuery,
        debugInfo: "$prefix -> forced query",
      );
    }

    // 5. Lazy load when LovView becomes visible while data is Pending or LoadedStale
    if (input.isVisible &&
        !input.queried &&
        (input.dataState.isPending || input.dataState.isLoadedStale)) {
      return LovNextUnitOutput(
        action: LovExecutionAction.query,
        missingIntent: MissingIntentType.dataLoadOrQuery,
        debugInfo: "$prefix -> lazy visible query",
      );
    }

    return LovNextUnitOutput(
      action: LovExecutionAction.none,
      debugInfo: "$prefix -> none",
    );
  }
}
