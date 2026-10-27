part of '_calc.dart';

class BlockExecutionCalculator {
  static BlockNextUnitOutput calculate(BlockNextUnitInput input) {
    final state = input.dataState;
    final intent = input.currentIntent;
    final hint = input.queryHint;

    String buildInfo(String branch) {
      return "$branch, ${input.modelName}, _executionIntent: $intent, "
          "dataState: ${state.toBriefInfo()}, "
          "queryHint: $hint, isVisibleX: ${input.isVisible}";
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (state.isNone) {
      return BlockNextUnitOutput(
        action: BlockExecutionAction.none,
        debugInfo: buildInfo("Block (1.1)"),
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (state.isPending) {
      final bool shouldQuery =
          (hint == QueryHint.force || input.isVisible) && !input.queried;
      if (shouldQuery) {
        final bool isQueryIntent = intent is BlockQueryIntent;
        return BlockNextUnitOutput(
          action: BlockExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Block (2.1)"),
        );
      } else {
        return BlockNextUnitOutput(
          action: BlockExecutionAction.none,
          debugInfo: buildInfo("Block (2.2)"),
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (state.isLoadedStale) {
      final bool shouldQuery =
          (hint == QueryHint.force || input.isVisible) && !input.queried;
      if (shouldQuery) {
        final bool isQueryIntent = intent is BlockQueryIntent;
        return BlockNextUnitOutput(
          action: BlockExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Block (3.1)"),
        );
      } else {
        return BlockNextUnitOutput(
          action: BlockExecutionAction.none,
          debugInfo: buildInfo("Block (3.2)"),
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FRESH
    // =========================================================================
    else if (state.isLoadedFresh) {
      // 4.0. Intercept terminal Done intent
      if (intent is BlockDoneIntent) {
        return BlockNextUnitOutput(
          action: BlockExecutionAction.none,
          debugInfo: buildInfo("Block (4.0)"),
        );
      }

      // 4.1. Force re-query explicitly requested
      if (hint == QueryHint.force) {
        final bool isQueryIntent = intent is BlockQueryIntent;
        return BlockNextUnitOutput(
          action: BlockExecutionAction.query,
          missingIntent:
              isQueryIntent ? null : MissingIntentType.dataLoadOrQuery,
          preserveCurrentIntent: !isQueryIntent && intent != null,
          debugInfo: buildInfo("Block (4.1)"),
        );
      }

      // IN: DATA STATE = FRESH
      // 4.2. Handle active execution intents
      if (intent != null) {
        if (intent is BlockDoneIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.none,
            debugInfo: buildInfo("Block (4.2.1)"),
          );
        } else if (intent is BlockNullIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.none,
            debugInfo: buildInfo("Block (4.2.2)"),
          );
        } else if (intent is BlockQueryIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.query,
            debugInfo: buildInfo("Block (4.2.3)"),
          );
        } else if (intent is BlockClearItemsIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.clearItems,
            debugInfo: buildInfo("Block (4.2.4)"),
          );
        } else if (intent is BlockDeleteItemIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.deleteItem,
            debugInfo: buildInfo("Block (4.2.5)"),
          );
        } else if (intent is BlockDeleteItemsIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.deleteItems,
            debugInfo: buildInfo("Block (4.2.6)"),
          );
        } else if (intent is BlockQuickItemUpdateIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.quickItemUpdate,
            debugInfo: buildInfo("Block (4.2.7)"),
          );
        } else if (intent is BlockQuickItemCreationIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.quickItemCreation,
            debugInfo: buildInfo("Block (4.2.8)"),
          );
        } else if (intent is BlockBackendActionIntent) {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.backendAction,
            debugInfo: buildInfo("Block (4.2.9)"),
          );
        } else {
          return BlockNextUnitOutput(
            action: BlockExecutionAction.none,
            debugInfo: buildInfo("Block (4.2.10)"),
          );
        }
      }

      // IN: DATA STATE = FRESH
      // 4.3. Idle state when dataset is fresh and no block-level intent is active
      return BlockNextUnitOutput(
        action: BlockExecutionAction.none,
        debugInfo: buildInfo("Block (4.3)"),
      );
    }

    // =========================================================================
    // 5. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return BlockNextUnitOutput(
      action: BlockExecutionAction.none,
      debugInfo: buildInfo("Block (5.1)"),
    );
  }
}
