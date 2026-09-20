part of '../core.dart';

class BlockCurrentItemResolver {
  /// Evaluates the target block's runtime environment, UI representations, and query batch
  /// to construct a comprehensive [BlockCurrentItemPlan].
  ///
  /// This plan determines:
  /// 1. Whether [candidateCurrItem] should be accepted as the active current item ([candidateAccepted]).
  /// 2. Whether an asynchronous detail fetch is required ([forceReloadItem]).
  ///
  /// **Core Architectural Guarantees**:
  /// - **Current Item Retention**: If the block already holds a valid current item and [candidateCurrItem]
  ///   matches it (`!isCandidateItemDifferentFromCurrent`), [candidateAccepted] is unconditionally guaranteed
  ///   to resolve to `true`, preventing existing selections from being unexpectedly deselected.
  /// - **Empty Workspace Protection**: If the block has no current item and no UI component requires an item context
  ///   (`provideItemContextExt == false`), new candidates from queried batches will NOT be forcibly set as current
  ///   under [BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed], preventing accidental selection/eviction loops.
  static BlockCurrentItemPlan resolveCurrentItem({
    required final ExecutionTrace executionTrace,
    required final XBlock thisXBlock,
    required final Object candidateCurrItem,
    required final bool inputForceReloadItem,
    required final bool provideBlockContext,
    required final bool provideItemContext,
    required final bool provideFormContext,
    required final AbsentItemContextPolicy
    absentItemContextPolicy,
    required final UnifiedItemRefreshPolicy unifiedItemRefreshPolicy,
    required final BlockSetCurrentItemDirective setCurrentItemDirective,
    required final bool isCandidateCurrentItemInNewQueriedList,
    required final bool isCandidateItemDifferentFromCurrent,
    required final bool debug,
  }) {
    final Block block = thisXBlock.block;

    return resolveCurrentItemInternal(
      executionTrace: executionTrace,
      itemType: block.getItemType(),
      itemDetailType: block.getItemDetailType(),
      candidateCurrItem: candidateCurrItem,
      inputForceReloadItem: inputForceReloadItem,
      provideBlockContext: provideBlockContext,
      provideItemContext: provideItemContext,
      provideFormContext: provideFormContext,
      absentItemContextPolicy: absentItemContextPolicy,
      unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
      setCurrentItemDirective: setCurrentItemDirective,
      isCandidateCurrentItemInNewQueriedList:
      isCandidateCurrentItemInNewQueriedList,
      isCandidateItemDifferentFromCurrent: isCandidateItemDifferentFromCurrent,
      debug: debug,
    );
  }

  /// Internal resolution logic decoupling domain models for headless unit testing.
  static BlockCurrentItemPlan resolveCurrentItemInternal({
    required final ExecutionTrace? executionTrace,
    required final Type itemType,
    required final Type itemDetailType,
    required final Object candidateCurrItem,
    required final bool inputForceReloadItem,
    required final bool provideBlockContext,
    required final bool provideItemContext,
    required final bool provideFormContext,
    required final AbsentItemContextPolicy
    absentItemContextPolicy,
    required final UnifiedItemRefreshPolicy unifiedItemRefreshPolicy,
    required final BlockSetCurrentItemDirective setCurrentItemDirective,
    required final bool isCandidateCurrentItemInNewQueriedList,
    required final bool isCandidateItemDifferentFromCurrent,
    required bool debug,
  }) {
    debug = true;

    // =========================================================================
    // 1. EXTEND REPRESENTATIVE POLICIES (DETERMINE IF UI DEMANDS AN ITEM CONTEXT)
    // =========================================================================
    // Determine whether an item representative is required by the active UI layout
    // or escalated by configuration policies/directives.
    bool provideItemContextExt = provideItemContext;
    if (!provideItemContext &&
        absentItemContextPolicy ==
            AbsentItemContextPolicy.trySetAnItemAsCurrent) {
      provideItemContextExt = true;
      PrintUtils.debug(debug,
          " --> [Calc 1.1] Extended ItemRep to true via ItemAbsentRepresentativePolicy.trySetAnItemAsCurrent");
    }

    switch (setCurrentItemDirective) {
      case BlockSetCurrentItemDirective.setAnItemAsCurrent:
      case BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm:
      case BlockSetCurrentItemDirective.refresh:
        provideItemContextExt = true;
        PrintUtils.debug(debug,
            " --> [Calc 1.2] Extended ItemRep to true via Directive: $setCurrentItemDirective");
      case BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed:
        break;
    }

    // =========================================================================
    // 2. RESOLVE CANDIDATE ACCEPTANCE DIRECTIVE
    // =========================================================================
    bool candidateAccepted;
    switch (setCurrentItemDirective) {
      case BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed:
      // Accept candidate IF:
      // 1. It is already the stable current item (!isCandidateItemDifferentFromCurrent), OR
      // 2. The UI explicitly requires an item context (provideItemContextExt).
        candidateAccepted =
            !isCandidateItemDifferentFromCurrent || provideItemContextExt;
        PrintUtils.debug(debug,
            " --> [Calc 2.1] Directive: setAnItemAsCurrentIfNeed, candidateAccepted: $candidateAccepted");

      case BlockSetCurrentItemDirective.setAnItemAsCurrent:
      case BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm:
      case BlockSetCurrentItemDirective.refresh:
        candidateAccepted = true;
        PrintUtils.debug(debug,
            " --> [Calc 2.2] Directive: $setCurrentItemDirective, candidateAccepted: true");
    }

    // =========================================================================
    // 3. UNIFORM ITEM OPTIMIZATION (ITEM == ITEM_DETAIL)
    // =========================================================================
    // When the domain ITEM is identical to ITEM_DETAIL, an additional detail fetch
    // can be skipped if the item was already fully refreshed in the newly queried batch.
    final bool isSameType = itemType == itemDetailType;
    final bool canSkipDetailFetch;

    if (isSameType) {
      if (unifiedItemRefreshPolicy == UnifiedItemRefreshPolicy.always) {
        canSkipDetailFetch = false;
        PrintUtils.debug(debug,
            " --> [Calc 3.1] Uniform ITEM: UnifiedItemRefreshPolicy.always -> canSkipDetailFetch: false");
      } else {
        canSkipDetailFetch = isCandidateCurrentItemInNewQueriedList;
        PrintUtils.debug(debug,
            " --> [Calc 3.2] Uniform ITEM: auto policy -> canSkipDetailFetch: $canSkipDetailFetch");
      }
    } else {
      canSkipDetailFetch = false;
      PrintUtils.debug(debug,
          " --> [Calc 3.3] Non-uniform ITEM (ITEM != ITEM_DETAIL) -> canSkipDetailFetch: false");
    }

    // =========================================================================
    // 4. CALCULATE FORCE RELOAD ITEM
    // =========================================================================
    bool retForceReloadItem = false;
    final bool isExplicitRefreshDirective =
        setCurrentItemDirective == BlockSetCurrentItemDirective.refresh;

    if (isExplicitRefreshDirective || inputForceReloadItem) {
      retForceReloadItem = true;
      PrintUtils.debug(debug,
          " --> [Calc 4.1] Force reload requested explicitly (directive / inputForceReloadItem) -> true");
    } else if (!provideItemContextExt) {
      retForceReloadItem = false;
      PrintUtils.debug(debug,
          " --> [Calc 4.2] No item representative present on active UI -> retForceReloadItem: false");
    } else {
      if (isCandidateItemDifferentFromCurrent) {
        retForceReloadItem = !canSkipDetailFetch;
        PrintUtils.debug(debug,
            " --> [Calc 4.3] Current item ID changed -> retForceReloadItem: $retForceReloadItem (!canSkipDetailFetch)");
      } else if (isCandidateCurrentItemInNewQueriedList) {
        retForceReloadItem = !canSkipDetailFetch;
        PrintUtils.debug(debug,
            " --> [Calc 4.4] Retained item present in newly queried batch -> retForceReloadItem: $retForceReloadItem");
      } else {
        retForceReloadItem = false;
        PrintUtils.debug(debug,
            " --> [Calc 4.5] Retained current item already loaded and stable -> retForceReloadItem: false");
      }
    }

    // =========================================================================
    // 5. TRACE STEP & CONSOLIDATED RESULT
    // =========================================================================
    executionTrace?._addTraceStep(
      codeId: "A12800",
      shortDesc: "Calculated Item Reload State:",
      parameters: {
        "candidateAccepted": candidateAccepted,
        "canSkipDetailFetch": canSkipDetailFetch,
        "provideItemContextExt": provideItemContextExt,
        "isCandidateItemDifferentFromCurrent":
        isCandidateItemDifferentFromCurrent,
        "retForceReloadItem": retForceReloadItem,
      },
    );

    return BlockCurrentItemPlan(
      candidateAccepted: candidateAccepted,
      forceReloadItem: retForceReloadItem,
    );
  }
}
