part of '_calc.dart';

class FilterExecutionCalculator {
  static FilterNextUnitOutput calculate(FilterNextUnitInput input) {
    final intent = input.currentIntent;
    final committed = input.committedDataState;
    final draft = input.draftDataState;
    final hint = input.filterLoadHint;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "committedDataState**: ${committed.toBriefInfo()}, draftDataState: ${draft.toBriefInfo()}, "
          "filterLoadHint: $hint, xFilterModel.loadedInSession: ${input.loadedInSession}.";
    }

    if (input.loadedInSession) {
      return FilterNextUnitOutput(
        action: FilterExecutionAction.none,
        debugInfo: buildInfo("FilterModel (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING.
    // =========================================================================
    if (committed.isPending) {
      final bool isLoadIntent = intent is FilterModelLoadIntent;
      return FilterNextUnitOutput(
        action: FilterExecutionAction.loadData,
        missingIntent: isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
        preserveCurrentIntent: !isLoadIntent && intent != null,
        debugInfo: buildInfo("FilterModel (2.1)"),
      );
    }

    // =========================================================================
    // 3. DATA STATE = ERROR (Data is missing or broken)
    // =========================================================================
    if (committed.isError) {
      if (intent is FilterModelDoneIntent) {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.none,
          debugInfo: buildInfo("FilterModel (3.0)"),
        );
      }
      if (intent == null) {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.loadData,
          missingIntent: MissingIntentType.dataLoadOrQuery,
          debugInfo: buildInfo("FilterModel (3.1)"),
        );
      }
      if (intent is FilterModelLoadIntent) {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.loadData,
          debugInfo: buildInfo("FilterModel (3.2)"),
        );
      } else if (intent is FilterModelFilterPanelChangeIntent) {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.panelChange,
          debugInfo: buildInfo("FilterModel (3.3)"),
        );
      } else {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.none,
          debugInfo: buildInfo("FilterModel (3.4)"),
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = LOADED (Data is ready)
    // =========================================================================
    else if (committed.isLoaded) {
      if (intent is FilterModelDoneIntent) {
        return FilterNextUnitOutput(
          action: FilterExecutionAction.none,
          debugInfo: buildInfo("FilterModel (4.0)"),
        );
      }

      if (hint == FilterLoadHint.force) {
        final bool isLoadIntent = intent is FilterModelLoadIntent;
        return FilterNextUnitOutput(
          action: FilterExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("FilterModel (4.1)"),
        );
      }

      if (intent != null) {
        if (intent is FilterModelDoneIntent) {
          return FilterNextUnitOutput(
            action: FilterExecutionAction.none,
            debugInfo: buildInfo("FilterModel (4.2.1)"),
          );
        } else if (intent is FilterModelFilterPanelChangeIntent) {
          return FilterNextUnitOutput(
            action: FilterExecutionAction.panelChange,
            debugInfo: buildInfo("FilterModel (4.2.2)"),
          );
        } else if (intent is FilterModelLoadIntent) {
          return FilterNextUnitOutput(
            action: FilterExecutionAction.loadData,
            debugInfo: buildInfo("FilterModel (4.2.3)"),
          );
        } else {
          return FilterNextUnitOutput(
            action: FilterExecutionAction.none,
            debugInfo: buildInfo("FilterModel (4.2.4)"),
          );
        }
      }

      return FilterNextUnitOutput(
        action: FilterExecutionAction.none,
        debugInfo: buildInfo("FilterModel (4.3)"),
      );
    }

    // =========================================================================
    // 5. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return FilterNextUnitOutput(
      action: FilterExecutionAction.none,
      debugInfo: buildInfo("FilterModel (5.1)"),
    );
  }
}
