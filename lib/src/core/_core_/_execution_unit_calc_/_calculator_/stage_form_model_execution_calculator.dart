part of '_calc.dart';

class StageFormExecutionCalculator {
  static StageFormNextUnitOutput calculate(StageFormNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.formLoadHint;
    final isVisible = input.isVisible;

    String buildInfo(String branch) {
      return "$branch, (${input.stageName}), _executionIntent: $intent, "
          "formDataState: ${state.toBriefInfo()}, _formLoadHint: $hint, visibleX: $isVisible";
    }

    if (intent is FormModelDoneIntent) {
      return StageFormNextUnitOutput(
        action: StageFormExecutionAction.none,
        debugInfo: buildInfo("StageFormModel (0.0)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      return StageFormNextUnitOutput(
        action: StageFormExecutionAction.none,
        debugInfo: buildInfo("StageFormModel (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (state.isPending) {
      if (intent is FormModelDataLoadIntent) {
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.loadData,
          debugInfo: buildInfo("StageFormModel (2.1)"),
        );
      }

      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.loadData,
          missingIntent: MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: intent != null,
          debugInfo: buildInfo("StageFormModel (2.2.1)"),
        );
      } else {
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.none,
          debugInfo: buildInfo("StageFormModel (2.2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isLoadedStale) {
      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("StageFormModel (3.1.1)"),
        );
      } else {
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.none,
          debugInfo: buildInfo("StageFormModel (3.1.2)"),
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FATAL ERROR
    // =========================================================================
    else if (state.isFatalError) {
      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("StageFormModel (4.1.1)"),
        );
      } else {
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.none,
          debugInfo: buildInfo("StageFormModel (4.1.2)"),
        );
      }
    }

    // =========================================================================
    // 5. DATA STATE = FRESH
    // =========================================================================
    else if (state.isLoadedFresh) {
      if (hint == FormLoadHint.force) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return StageFormNextUnitOutput(
          action: StageFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("StageFormModel (5.1.2)"),
        );
      }

      if (intent != null) {
        if (intent is FormModelViewChangeIntent) {
          return StageFormNextUnitOutput(
            action: StageFormExecutionAction.viewChange,
            debugInfo: buildInfo("StageFormModel (5.2.2)"),
          );
        } else if (intent is FormModelDataLoadIntent) {
          return StageFormNextUnitOutput(
            action: StageFormExecutionAction.loadData,
            debugInfo: buildInfo("StageFormModel (5.2.3)"),
          );
        } else if (intent is FormModelPatchFormFieldsIntent) {
          return StageFormNextUnitOutput(
            action: StageFormExecutionAction.patchFormFields,
            debugInfo: buildInfo("StageFormModel (5.2.4)"),
          );
        } else {
          return StageFormNextUnitOutput(
            action: StageFormExecutionAction.none,
            debugInfo: buildInfo("StageFormModel (5.2.5)"),
          ); // Fix trùng lặp log 5.2.4
        }
      }

      return StageFormNextUnitOutput(
        action: StageFormExecutionAction.none,
        debugInfo: buildInfo("StageFormModel (5.3)"),
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return StageFormNextUnitOutput(
      action: StageFormExecutionAction.none,
      debugInfo: buildInfo("StageFormModel (6.1)"),
    );
  }
}
