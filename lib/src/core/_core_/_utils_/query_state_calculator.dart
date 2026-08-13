import '../../enums/action_result_state.dart';
import '../../enums/block_viewport_sync_strategy.dart';
import '../../enums/data_state.dart';
import '../../enums/fallback_dilemma_strategy.dart';
import '../../enums/list_update_strategy.dart';
import '../../enums/block_loaded_state_phase.dart';

import '../../enums/loaded_state_stale_reason.dart';
import '../../error/_block_error_info.dart';
import '../core.dart';

/// Immutable parameter blueprint feeding into the state calculator engine.
class QueryCalculatorInput {
  /// The resulting outcome of the active remote data fetch cycle.
  final ActionResultState queryResultState;

  final BlockErrorInfo? blockErrorInfo;

  /// The current state ledger bound to the active runtime block.
  final BlockDataState currentDataState;

  /// The viewport alignment boundary requested by the triggering mutation or refresh task.
  final BlockViewportSyncStrategy syncStrategy;

  /// Context boundary mutation flag indicating parent shifts or search criteria changes.
  final bool parentOrCriteriaChanged;

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

  const QueryCalculatorInput({
    required this.queryResultState,
    required this.blockErrorInfo,
    required this.currentDataState,
    required this.syncStrategy,
    required this.parentOrCriteriaChanged,
    required this.isQueryMore,
    required this.isPageShifting,
    required this.queryTypeChanged,
    required this.suggestedListUpdateStrategy,
    required this.hasRemoveItemIds,
    this.dilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache,
  });
}

/// Consolidated execution blueprint resolved by the calculator matrix.
class QueryCalculatorResult {
  /// The final storage mutation strategy passed onto the active rendering dataset list.
  final ListUpdateStrategy realListUpdateStrategy;

  /// The next structural lifecycle state target assigned onto the running block.
  final BlockDataState newBlockDataState;

  /// The fine-grained operational phase when [newBlockDataState] resolves to [BlockDataStateLoaded].
  final BlockLoadedStatePhase? newLoadedPhase;

  /// Indicator commanding the processor to forcefully prune missing locally cached items.
  final bool forcePruneMissingIds;

  const QueryCalculatorResult({
    required this.realListUpdateStrategy,
    required this.newBlockDataState,
    this.newLoadedPhase,
    required this.forcePruneMissingIds,
  });
}

class QueryStateCalculator {
  /// Pure mathematical evaluation matrix resolving viewport mutations and data lifecycles safely.
  ///
  /// Guarantees absolute isolation, making state modifications completely side-effect free.
  static QueryCalculatorResult calculate(QueryCalculatorInput input) {
    ListUpdateStrategy resolvedStrategy;
    BlockDataState resolvedState;
    BlockLoadedStatePhase? resolvedPhase;
    bool shouldPrune = false;

    // =========================================================================
    // 🛑 BRANCH 1: REMOTE RE-QUERY LIFECYCLE FAILED
    // =========================================================================
    if (input.queryResultState == ActionResultState.fail) {
      // Case 1.1: Context shifted (Parent or Filter Criteria changed)
      // Since context is new and query failed, fallback to cold PENDING state
      if (input.parentOrCriteriaChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
        resolvedState = BlockDataStatePending(
          reason: PendingReasonFetchFailed(errorInfo: input.blockErrorInfo),
        );
        resolvedPhase = null;
      }
      // Case 1.2: Context preserved -> Evaluate based on previous structural stability
      else {
        if (input.currentDataState.isLoaded) {
          if (input.hasRemoveItemIds) {
            // EAGER LOCAL PRUNING: Keep non-mutated rows loaded, flag for local trash removal
            resolvedStrategy = ListUpdateStrategy.merge;
            resolvedState = const BlockDataStateLoadedStale(
              reason: LoadedStateStaleReason.fetchFailed,
            );
            resolvedPhase = BlockLoadedStatePhase.mutationFailed;
            shouldPrune = true;
          } else if (input.isQueryMore || input.isPageShifting) {
            // EVALUATE FALLBACK DILEMMA POLICY FOR INLINE PAGE SHIFTS & LAZY LOADS
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedStrategy = ListUpdateStrategy.replace;
              resolvedState = BlockDataStatePending(
                reason:
                    PendingReasonFetchFailed(errorInfo: input.blockErrorInfo),
              );
              resolvedPhase = null;
            } else {
              resolvedStrategy = ListUpdateStrategy.merge;
              // Preserve existing loaded state or mark stale due to fetch failure
              resolvedState = input.currentDataState.isStale
                  ? input.currentDataState
                  : const BlockDataStateLoadedStale(
                      reason: LoadedStateStaleReason.fetchFailed,
                    );
              resolvedPhase = BlockLoadedStatePhase.fetchMoreFailed;
            }
          } else {
            // Standard root refresh/re-query failure preserves baseline cache under modern UX rules
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedStrategy = ListUpdateStrategy.replace;
              resolvedState = BlockDataStatePending(
                reason:
                    PendingReasonFetchFailed(errorInfo: input.blockErrorInfo),
              );
              resolvedPhase = null;
            } else {
              resolvedStrategy = ListUpdateStrategy.merge;
              resolvedState = const BlockDataStateLoadedStale(
                reason: LoadedStateStaleReason.fetchFailed,
              );
              resolvedPhase = BlockLoadedStatePhase.refetchFailed;
            }
          }
        } else {
          // Viewport was already uninitialized or pending before the crash -> Stay in PENDING
          resolvedStrategy = ListUpdateStrategy.replace;
          resolvedState = BlockDataStatePending(
            reason: PendingReasonFetchFailed(errorInfo: input.blockErrorInfo),
          );
          resolvedPhase = null;
        }
      }
    }
    // =========================================================================
    // 🎉 BRANCH 2: REMOTE RE-QUERY LIFECYCLE SUCCEEDED
    // =========================================================================
    else {
      // Successful remote sync mounts fresh loaded baseline data
      resolvedState = const BlockDataStateLoadedFresh();
      resolvedPhase = BlockLoadedStatePhase.idle;

      // Case 2.1: Fresh context loaded successfully -> Flush and mount the new grid rows
      if (input.parentOrCriteriaChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
      }
      // Case 2.2: Fetch complete for an unchanged stable context -> Distribute via sync rules
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

    return QueryCalculatorResult(
      realListUpdateStrategy: resolvedStrategy,
      newBlockDataState: resolvedState,
      newLoadedPhase: resolvedPhase,
      forcePruneMissingIds: shouldPrune,
    );
  }
}
