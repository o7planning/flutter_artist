part of '_calc.dart';

class BlockFormExecutionCalculator {
  static BlockFormNextUnitOutput calculate(BlockFormNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.formLoadHint;
    final isVisible = input.isVisible;
    final formMode = input.formMode;

    String buildInfo(String branch) {
      return "$branch, (${input.blockName}), _executionIntent: $intent, "
          "formDataState: ${state.toBriefInfo()}, formMode: ${formMode.name}, _formLoadHint: $hint, visibleX: $isVisible";
    }

    if (intent is FormModelDoneIntent) {
      return BlockFormNextUnitOutput(
        action: BlockFormExecutionAction.none,
        debugInfo: buildInfo("BlockFormModel (0.0)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      return BlockFormNextUnitOutput(
        action: BlockFormExecutionAction.none,
        debugInfo: buildInfo("BlockFormModel (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (state.isPending) {
      if (intent is FormModelDataLoadIntent) {
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.loadData,
          debugInfo: buildInfo("BlockFormModel (2.1)"),
        );
      }

      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.loadData,
          missingIntent: MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: intent != null,
          debugInfo: buildInfo("BlockFormModel (2.2.1)"),
        );
      } else {
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.none,
          debugInfo: buildInfo("BlockFormModel (2.2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isStale) {
      final bool shouldLoad = (hint == FormLoadHint.force || isVisible);
      if (shouldLoad) {
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("BlockFormModel (3.1.1)"),
        );
      } else {
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.none,
          debugInfo: buildInfo("BlockFormModel (3.1.2)"),
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
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("BlockFormModel (4.1.1)"),
        );
      } else {
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.none,
          debugInfo: buildInfo("BlockFormModel (4.1.2)"),
        );
      }
    }

    // =========================================================================
    // 5. DATA STATE = FRESH
    // =========================================================================
    else if (state.isFresh) {
      if (hint == FormLoadHint.force) {
        if (formMode == BlockFormMode.creation) {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.none,
            debugInfo: buildInfo("BlockFormModel (5.1.1)"),
          );
        }
        final bool isLoadIntent = intent is FormModelDataLoadIntent;
        return BlockFormNextUnitOutput(
          action: BlockFormExecutionAction.loadData,
          missingIntent:
              isLoadIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isLoadIntent && intent != null,
          debugInfo: buildInfo("BlockFormModel (5.1.2)"),
        );
      }

      if (intent != null) {
        if (intent is FormModelViewChangeIntent) {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.viewChange,
            debugInfo: buildInfo("BlockFormModel (5.2.2)"),
          );
        } else if (intent is FormModelDataLoadIntent) {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.loadData,
            debugInfo: buildInfo("BlockFormModel (5.2.3)"),
          );
        } else if (intent is FormModelSaveIntent) {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.save,
            debugInfo: buildInfo("BlockFormModel (5.2.4)"),
          );
        } else if (intent is FormModelPatchFormFieldsIntent) {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.patchFormFields,
            debugInfo: buildInfo("BlockFormModel (5.2.5)"),
          );
        } else {
          return BlockFormNextUnitOutput(
            action: BlockFormExecutionAction.none,
            debugInfo: buildInfo("BlockFormModel (5.2.6)"),
          );
        }
      }

      return BlockFormNextUnitOutput(
        action: BlockFormExecutionAction.none,
        debugInfo: buildInfo("BlockFormModel (5.3)"),
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return BlockFormNextUnitOutput(
      action: BlockFormExecutionAction.none,
      debugInfo: buildInfo("BlockFormModel (6.1)"),
    );
  }
}
