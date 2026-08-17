import '../../enums/action_result_state.dart';
import '../../enums/block_loaded_state_phase.dart';
import '../../enums/block_viewport_sync_strategy.dart';
import '../../enums/error_origin.dart';
import '../../enums/fallback_dilemma_strategy.dart';
import '../../enums/list_update_strategy.dart';
import '../../error/_block_error_info.dart';
import '../core.dart';

/// Immutable parameter blueprint feeding into the state calculator engine.
class BlockQueryCalculatorInput {
  /// The resulting outcome of the active remote data fetch cycle.
  final ActionResultState queryResultState;

  /// Identifies the architectural source/trigger of the failure, or null if no error occurred.
  final BlockErrorOrigin? blockErrorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if any.
  final BlockErrorInfo? blockErrorInfo;

  /// The current state ledger bound to the active runtime block.
  final BlockDataState currentDataState;

  /// The viewport alignment boundary requested by the triggering mutation or refresh task.
  final BlockViewportSyncStrategy syncStrategy;

  /// Criteria shift flag indicating whether search criteria or filter inputs mutated for this query.
  final bool filterCriteriaChanged;

  /// Infinite scroll / lazy append trigger flag mapped from [TaskType.queryMore].
  final bool isQueryMore;

  /// Page movement flag indicating sequential hard pagination changes (next, previous, or jump).
  final bool isPageShifting;

  /// Structural strategy shift flag checking if the query structure itself morphed.
  final bool queryTypeChanged;

  /// The baseline default strategy assigned onto the primary structural XBlock.
  final ListUpdateStrategy? suggestedListUpdateStrategy;

  /// Deletion tracking flag indicating whether this query follows a destructive [BlockBackendAction].
  final bool hasRemoveItemIds;

  /// The explicit rule dictating how to resolve cached data when pagination operations fail.
  final FallbackDilemmaStrategy dilemmaStrategy;

  const BlockQueryCalculatorInput({
    required this.queryResultState,
    required this.blockErrorOrigin,
    required this.blockErrorInfo,
    required this.currentDataState,
    required this.syncStrategy,
    required this.filterCriteriaChanged,
    required this.isQueryMore,
    required this.isPageShifting,
    required this.queryTypeChanged,
    required this.suggestedListUpdateStrategy,
    required this.hasRemoveItemIds,
    this.dilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache,
  });

  String getDebugInfo() {
    return "--------- BlockQueryCalculatorInput -------------- \n"
        "   - blockErrorOrigin: $blockErrorOrigin \n"
        "   - blockErrorInfo: $blockErrorInfo \n"
        "   - currentDataState: $currentDataState \n"
        "   - syncStrategy: $syncStrategy \n"
        "   - filterCriteriaChanged: $filterCriteriaChanged \n"
        "   - isQueryMore: $isQueryMore \n"
        "   - isPageShifting: $isPageShifting \n"
        "   - queryTypeChanged: $queryTypeChanged \n"
        "   - suggestedListUpdateStrategy: $suggestedListUpdateStrategy \n"
        "   - hasRemoveItemIds: $hasRemoveItemIds \n"
        "   - dilemmaStrategy: $dilemmaStrategy \n";
  }
}

/// Consolidated execution blueprint resolved by the calculator matrix.
class BlockQueryCalculatorResult {
  /// The final storage mutation strategy passed onto the active rendering dataset list.
  final ListUpdateStrategy realListUpdateStrategy;

  /// The next structural lifecycle state target assigned onto the running block.
  final BlockDataState newBlockDataState;

  /// The fine-grained operational phase when [newBlockDataState] resolves to [BlockDataStateLoaded].
  final BlockLoadedStatePhase? newLoadedPhase;

  /// Indicator commanding the processor to forcefully prune missing locally cached items.
  final bool forcePruneMissingIds;

  const BlockQueryCalculatorResult({
    required this.realListUpdateStrategy,
    required this.newBlockDataState,
    this.newLoadedPhase,
    required this.forcePruneMissingIds,
  });

  String getDebugInfo() {
    return "--------- BlockQueryCalculatorResult -------------- \n"
        "   - realListUpdateStrategy: $realListUpdateStrategy \n"
        "   - newBlockDataState: $newBlockDataState \n"
        "   - newLoadedPhase: $newLoadedPhase \n"
        "   - forcePruneMissingIds: $forcePruneMissingIds \n";
  }
}

class BlockQueryStateCalculator {
  /// Pure mathematical evaluation matrix resolving viewport mutations and data lifecycles safely.
  ///
  /// Guarantees absolute isolation, making state modifications completely side-effect free.
  static BlockQueryCalculatorResult calculate(BlockQueryCalculatorInput input) {
    ListUpdateStrategy resolvedStrategy;
    BlockDataState resolvedState;
    BlockLoadedStatePhase? resolvedPhase;
    bool shouldPrune = false;

    // =========================================================================
    // 🛑 BRANCH 1: REMOTE RE-QUERY LIFECYCLE FAILED
    // =========================================================================
    if (input.queryResultState == ActionResultState.fail) {
      final effectiveOrigin =
          input.blockErrorOrigin ?? BlockErrorOrigin.directFetch;

      // Case 1.1: Criteria mutated (Search/Filter changed)
      if (input.filterCriteriaChanged) {
        if (input.currentDataState.isLoaded &&
            input.dilemmaStrategy ==
                FallbackDilemmaStrategy.preserveStableCache) {
          // Preserve previous dataset on screen, but mark as STALE due to criteria mismatch & fetch error
          resolvedStrategy = ListUpdateStrategy.merge;
          resolvedState = BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReasonFailed(
              errorInfo: input.blockErrorInfo,
            ),
          );
          resolvedPhase = BlockLoadedStatePhase.refetchFailed;
        } else {
          // Hard eviction or cold baseline failure -> Fallback to cold PENDING
          resolvedStrategy = ListUpdateStrategy.replace;
          resolvedState = BlockDataStatePending.failed(
            errorOrigin: effectiveOrigin,
            errorInfo: input.blockErrorInfo,
          );
          resolvedPhase = null;
        }
      }
      // Case 1.2: Criteria preserved -> Evaluate based on previous structural stability
      else {
        if (input.currentDataState.isLoaded) {
          if (input.hasRemoveItemIds) {
            // EAGER LOCAL PRUNING: Keep non-mutated rows loaded, flag for local trash removal
            resolvedStrategy = ListUpdateStrategy.merge;
            resolvedState = BlockDataStateLoadedStale(
              reason: BlockLoadedStateStaleReasonFailed(
                errorInfo: input.blockErrorInfo,
              ),
            );
            resolvedPhase = BlockLoadedStatePhase.mutationFailed;
            shouldPrune = true;
          } else if (input.isQueryMore || input.isPageShifting) {
            // EVALUATE FALLBACK DILEMMA POLICY FOR INLINE PAGE SHIFTS & LAZY LOADS
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedStrategy = ListUpdateStrategy.replace;
              resolvedState = BlockDataStatePending.failed(
                errorOrigin: effectiveOrigin,
                errorInfo: input.blockErrorInfo,
              );
              resolvedPhase = null;
            } else {
              resolvedStrategy = ListUpdateStrategy.merge;
              // Incremental fetch/pagination failure preserves baseline data freshness while attaching transient error
              resolvedState = input.currentDataState.isStale
                  ? input.currentDataState
                  : BlockDataStateLoadedFresh(
                      transientErrorInfo: input.blockErrorInfo,
                    );
              resolvedPhase = BlockLoadedStatePhase.fetchMoreFailed;
            }
          } else {
            // Standard root refresh/re-query failure preserves baseline cache under modern UX rules
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedStrategy = ListUpdateStrategy.replace;
              resolvedState = BlockDataStatePending.failed(
                errorOrigin: effectiveOrigin,
                errorInfo: input.blockErrorInfo,
              );
              resolvedPhase = null;
            } else {
              resolvedStrategy = ListUpdateStrategy.merge;
              resolvedState = BlockDataStateLoadedStale(
                reason: BlockLoadedStateStaleReasonFailed(
                  errorInfo: input.blockErrorInfo,
                ),
              );
              resolvedPhase = BlockLoadedStatePhase.refetchFailed;
            }
          }
        } else {
          // Viewport was already uninitialized or pending before the crash -> Stay in PENDING
          resolvedStrategy = ListUpdateStrategy.replace;
          resolvedState = BlockDataStatePending.failed(
            errorOrigin: effectiveOrigin,
            errorInfo: input.blockErrorInfo,
          );
          resolvedPhase = null;
        }
      }
    }
    // =========================================================================
    // 🎉 BRANCH 2: REMOTE RE-QUERY LIFECYCLE SUCCEEDED
    // =========================================================================
    else {
      // Successful remote sync mounts fresh loaded baseline data (clearing transient errors)
      resolvedState = const BlockDataStateLoadedFresh();
      resolvedPhase = BlockLoadedStatePhase.idle;

      // Case 2.1: Criteria mutated successfully -> Flush and mount the new grid rows
      if (input.filterCriteriaChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
      }
      // Case 2.2: Fetch complete for unchanged criteria -> Distribute via sync rules
      else {
        switch (input.syncStrategy) {
          case BlockViewportSyncStrategy.nativeQuery:
            resolvedStrategy =
                input.suggestedListUpdateStrategy ?? ListUpdateStrategy.replace;
            break;
          case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
            resolvedStrategy = ListUpdateStrategy.replace;
            break;
          case BlockViewportSyncStrategy.effectedItemIdsQuery:
            resolvedStrategy = ListUpdateStrategy.merge;
            break;
        }
      }

      // Hard override: If the pipeline query layout model structurally mutated, enforce replace
      if (input.queryTypeChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
      }
    }

    return BlockQueryCalculatorResult(
      realListUpdateStrategy: resolvedStrategy,
      newBlockDataState: resolvedState,
      newLoadedPhase: resolvedPhase,
      forcePruneMissingIds: shouldPrune,
    );
  }

  /// Pure state calculator when criteria extraction or FilterModel fails directly.
  static BlockDataState calculateOnFilterError({
    required BlockDataState currentDataState,
    required BlockErrorOrigin blockErrorOrigin,
    required BlockErrorInfo? blockErrorInfo,
    required FallbackDilemmaStrategy dilemmaStrategy,
  }) {
    if (currentDataState.isNone) {
      return const BlockDataStateNone();
    }

    if (currentDataState.isPending) {
      return BlockDataStatePending.failed(
        errorOrigin: blockErrorOrigin,
        errorInfo: blockErrorInfo,
      );
    }

    // Loaded
    if (dilemmaStrategy == FallbackDilemmaStrategy.preserveStableCache) {
      return BlockDataStateLoadedStale(
        reason: BlockLoadedStateStaleReasonFailed(errorInfo: blockErrorInfo),
      );
    }
    return BlockDataStatePending.failed(
      errorOrigin: BlockErrorOrigin.filterModel,
      errorInfo: blockErrorInfo,
    );
  }
}
