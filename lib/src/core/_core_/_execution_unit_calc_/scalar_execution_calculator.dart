part of '_calc.dart';

class ScalarExecutionCalculator {
  static ScalarNextUnitOutput calculate(ScalarNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.queryHint;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "dataState: ${state.toBriefInfo()}, queryHint: $hint, isVisibleX: ${input.isVisible}";
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      return ScalarNextUnitOutput(
        action: ScalarExecutionAction.none,
        debugInfo: buildInfo("Scalar (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (state.isPending) {
      final bool shouldQuery =
          (hint == QueryHint.force || input.isVisible) && !input.queried;

      if (shouldQuery) {
        final bool isQueryIntent = intent is ScalarQueryIntent;
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Scalar (2.1)"),
        );
      } else {
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.none,
          debugInfo: buildInfo("Scalar (2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isStale) {
      final bool shouldQuery =
          (hint == QueryHint.force || input.isVisible) && !input.queried;

      if (shouldQuery) {
        final bool isQueryIntent = intent is ScalarQueryIntent;
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Scalar (3.1)"),
        );
      } else {
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.none,
          debugInfo: buildInfo("Scalar (3.2)"),
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FRESH
    // =========================================================================
    else if (state.isFresh) {
      // 4.0. Intercept terminal Done intent
      if (intent is ScalarDoneIntent) {
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.none,
          debugInfo: buildInfo("Scalar (4.0)"),
        );
      }

      // 4.1. Force re-query explicitly requested
      if (hint == QueryHint.force) {
        final bool isQueryIntent = intent is ScalarQueryIntent;
        return ScalarNextUnitOutput(
          action: ScalarExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Scalar (4.1)"),
        );
      }

      // 4.2. Handle active execution intents
      if (intent != null) {
        if (intent is ScalarDoneIntent) {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.none,
            debugInfo: buildInfo("Scalar (4.2.1)"),
          );
        } else if (intent is ScalarNullIntent) {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.none,
            debugInfo: buildInfo("Scalar (4.2.2)"),
          );
        } else if (intent is ScalarQueryIntent) {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.query,
            debugInfo: buildInfo("Scalar (4.2.3)"),
          );
        } else if (intent is ScalarLoadExtraDataQuickActionIntent) {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.loadExtraData,
            debugInfo: buildInfo("Scalar (4.2.4)"),
          );
        } else if (intent is ScalarClearIntent) {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.clear,
            debugInfo: buildInfo("Scalar (4.2.5)"),
          );
        } else {
          return ScalarNextUnitOutput(
            action: ScalarExecutionAction.none,
            debugInfo: buildInfo("Scalar (4.2.6)"),
          );
        }
      }

      // 4.3. Idle state when data is fresh and no intent is active
      return ScalarNextUnitOutput(
        action: ScalarExecutionAction.none,
        debugInfo: buildInfo("Scalar (4.3)"),
      );
    }

    // =========================================================================
    // 5. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return ScalarNextUnitOutput(
      action: ScalarExecutionAction.none,
      debugInfo: buildInfo("Scalar (5.1)"),
    );
  }
}
