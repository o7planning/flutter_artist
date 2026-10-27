part of '_calc.dart';

class BlockCurrentItemExecutionCalculator {
  static BlockCurrentItemNextUnitOutput calculate(
      BlockCurrentItemNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final isVisible = input.isVisible;
    final forceReload = input.forceReloadCurrItem;

    String buildInfo(String branch) {
      return "$branch, (${input.modelName}), _executionIntent: $intent, "
          "itemDataState: ${state.toBriefInfo()}, forceReloadCurrItem: $forceReload, "
          "isVisibleX: $isVisible, blockFormMode: ${input.formMode}";
    }

    if (intent is BlockCurrentItemModelDoneIntent) {
      return BlockCurrentItemNextUnitOutput(
        action: BlockCurrentItemExecutionAction.none,
        debugInfo: buildInfo("BlockCurrentItemModel (0.0)"),
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      // IN: DATA STATE = NONE
      // intent == null
      if (intent == null) {
        final bool shouldLoad =
            (input.forceReloadCurrItem || input.isVisible) &&
                input.formMode != BlockFormMode.creation;
        if (shouldLoad) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.setCurrentItem,
            missingIntent: MissingIntentType.setItemAsCurrent,
            preserveCurrentIntent: false,
            debugInfo: buildInfo("BlockCurrentItemModel (1.1.1)"),
          );
        } else {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.none,
            debugInfo: buildInfo("BlockCurrentItemModel (1.1.2)"),
          );
        }
      }

      // IN: DATA STATE = NONE
      // BlockCurrentItemModelSetCurrentItemIntent
      if (intent is BlockCurrentItemModelSetCurrentItemIntent) {
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.setCurrentItem,
          debugInfo: buildInfo("BlockCurrentItemModel (1.2.1)"),
        );
      }
      // IN: DATA STATE = NONE
      // BlockCurrentItemModelClearCurrentItemIntent
      else if (intent is BlockCurrentItemModelClearCurrentItemIntent) {
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.clearCurrentItem,
          debugInfo: buildInfo("BlockCurrentItemModel (1.2.2)"),
        );
      }
      // IN: DATA STATE = NONE
      // BlockCurrentItemModelPrepareFormToCreateItemIntent
      else if (intent is BlockCurrentItemModelPrepareFormToCreateItemIntent) {
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.prepareFormToCreate,
          debugInfo: buildInfo("BlockCurrentItemModel (1.2.3)"),
        );
      }
      // IN: DATA STATE = NONE
      // Other intent.
      else {
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.none,
          debugInfo: buildInfo("BlockCurrentItemModel (1.2.4)"),
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = FRESH
    // =========================================================================
    else if (state.isFresh) {
      if (forceReload) {
        final bool isSetIntent =
            intent is BlockCurrentItemModelSetCurrentItemIntent;
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.setCurrentItem,
          missingIntent:
              isSetIntent ? null : MissingIntentType.setItemAsCurrent,
          preserveCurrentIntent: !isSetIntent && intent != null,
          debugInfo: buildInfo("BlockCurrentItemModel (2.1)"),
        );
      }
      // IN: DATA STATE = FRESH
      if (intent != null) {
        // IN: DATA STATE = FRESH
        // BlockCurrentItemModelSetCurrentItemIntent
        if (intent is BlockCurrentItemModelSetCurrentItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.setCurrentItem,
            debugInfo: buildInfo("BlockCurrentItemModel (2.2.1)"),
          );
        }
        // IN: DATA STATE = FRESH
        // BlockCurrentItemModelClearCurrentItemIntent
        else if (intent is BlockCurrentItemModelClearCurrentItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.clearCurrentItem,
            debugInfo: buildInfo("BlockCurrentItemModel (2.2.2)"),
          );
        }
        // IN: DATA STATE = FRESH
        // BlockCurrentItemModelPrepareFormToCreateItemIntent
        else if (intent is BlockCurrentItemModelPrepareFormToCreateItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.prepareFormToCreate,
            debugInfo: buildInfo("BlockCurrentItemModel (2.2.3)"),
          );
        }
        // IN: DATA STATE = FRESH
        // Other intent.
        else {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.none,
            debugInfo: buildInfo("BlockCurrentItemModel (2.2.4)"),
          );
        }
      }
      return BlockCurrentItemNextUnitOutput(
        action: BlockCurrentItemExecutionAction.none,
        debugInfo: buildInfo("BlockCurrentItemModel (2.3)"),
      );
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isStale) {
      final bool shouldReload = forceReload || isVisible;
      if (shouldReload) {
        final bool isSetIntent =
            intent is BlockCurrentItemModelSetCurrentItemIntent;
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.setCurrentItem,
          missingIntent:
              isSetIntent ? null : MissingIntentType.setItemAsCurrent,
          preserveCurrentIntent: !isSetIntent && intent != null,
          debugInfo: buildInfo("BlockCurrentItemModel (3.1)"),
        );
      }

      // IN: DATA STATE = STALE
      if (intent != null) {
        // IN: DATA STATE = STALE
        // BlockCurrentItemModelSetCurrentItemIntent
        if (intent is BlockCurrentItemModelSetCurrentItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.setCurrentItem,
            debugInfo: buildInfo("BlockCurrentItemModel (3.2.1)"),
          );
        }
        // IN: DATA STATE = STALE
        // BlockCurrentItemModelClearCurrentItemIntent
        else if (intent is BlockCurrentItemModelClearCurrentItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.clearCurrentItem,
            debugInfo: buildInfo("BlockCurrentItemModel (3.2.2)"),
          );
        }
        // IN: DATA STATE = STALE
        // BlockCurrentItemModelPrepareFormToCreateItemIntent
        else if (intent is BlockCurrentItemModelPrepareFormToCreateItemIntent) {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.prepareFormToCreate,
            debugInfo: buildInfo("BlockCurrentItemModel (3.2.3)"),
          );
        }
        // IN: DATA STATE = STALE
        // Others
        else {
          return BlockCurrentItemNextUnitOutput(
            action: BlockCurrentItemExecutionAction.none,
            debugInfo: buildInfo("BlockCurrentItemModel (3.2.4)"),
          );
        }
      }
      // intent == null
      else {
        return BlockCurrentItemNextUnitOutput(
          action: BlockCurrentItemExecutionAction.none,
          debugInfo: buildInfo("BlockCurrentItemModel (3.3)"),
        );
      }
    }

    // =========================================================================
    // 4. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return BlockCurrentItemNextUnitOutput(
      action: BlockCurrentItemExecutionAction.none,
      debugInfo: buildInfo("BlockCurrentItemModel (4.1)"),
    );
  }
}
