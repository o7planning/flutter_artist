import '../enums/_action_result_state.dart';
import '../enums/_block_viewport_sync_strategy.dart';
import '../enums/_data_state.dart';
import '../enums/_fallback_dilemma_strategy.dart';
import '../enums/_list_update_strategy.dart';

/// Immutable parameter blueprint feeding into the state calculator engine.
class QueryCalculatorInput {
  /// The resulting outcome of the active remote data fetch cycle.
  final ActionResultState queryResultState;

  /// The current state ledger bound to the active runtime block.
  final DataState currentDataState;

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
  final DataState newBlockDataState;

  /// Indicator commanding the processor to forcefully prune missing locally cached items.
  final bool forcePruneMissingIds;

  const QueryCalculatorResult({
    required this.realListUpdateStrategy,
    required this.newBlockDataState,
    required this.forcePruneMissingIds,
  });
}

class QueryStateCalculator {
  /// Pure mathematical evaluation matrix resolving viewport mutations and data lifecycles safely.
  ///
  /// Guarantees absolute isolation, making state modifications completely side-effect free.
  static QueryCalculatorResult calculate(QueryCalculatorInput input) {
    ListUpdateStrategy resolvedStrategy;
    DataState resolvedState;
    bool shouldPrune = false;

    // =========================================================================
    //  BRANCH 1: REMOTE RE-QUERY LIFECYCLE FAILED
    // =========================================================================
    if (input.queryResultState == ActionResultState.fail) {
      // Case 1.1: Context shifted -> Outdated data must be completely scrubbed
      if (input.parentOrCriteriaChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
        resolvedState = DataState.error;
      }
      // Case 1.2: Context preserved -> Evaluate based on previous structural stability
      else {
        if (input.currentDataState == DataState.ready) {
          if (input.hasRemoveItemIds) {
            // EAGER LOCAL PRUNING: Keep non-mutated rows ready, but flag for local trash removal
            resolvedStrategy = ListUpdateStrategy.merge;
            resolvedState = DataState.ready;
            shouldPrune = true;
          } else if (input.isQueryMore || input.isPageShifting) {
            // EVALUATE FALLBACK DILEMMA POLICY FOR INLINE PAGE SHIFTS & LAZY LOADS
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedStrategy = ListUpdateStrategy.replace;
              resolvedState = DataState.error;
            } else {
              resolvedStrategy = ListUpdateStrategy.merge;
              resolvedState = DataState.ready;
            }
          } else {
            // Standard root refresh/re-query failures collapse whole viewport consistency bounds
            resolvedStrategy = ListUpdateStrategy.replace;
            resolvedState = DataState.error;
          }
        } else {
          // Viewport was already unstable before the crash -> Force strict error boundary
          resolvedStrategy = ListUpdateStrategy.replace;
          resolvedState = DataState.error;
        }
      }
    }
    // =========================================================================
    //  BRANCH 2: REMOTE RE-QUERY LIFECYCLE SUCCEEDED
    // =========================================================================
    else {
      // Case 2.1: Fresh context loaded successfully -> Flush and mount the new grid rows
      if (input.parentOrCriteriaChanged) {
        resolvedStrategy = ListUpdateStrategy.replace;
        resolvedState = DataState.ready;
      }
      // Case 2.2: Fetch complete for an unchanged stable context -> Distribute via sync rules
      else {
        resolvedState = DataState.ready;
        switch (input.syncStrategy) {
          case BlockViewportSyncStrategy.forceNativeQuery:
            resolvedStrategy =
                input.suggestedListUpdateStrategy ?? ListUpdateStrategy.replace;
            break;
          case BlockViewportSyncStrategy.convergeAll:
            resolvedStrategy = ListUpdateStrategy.replace;
            break;
          case BlockViewportSyncStrategy.incrementalMerge:
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
      forcePruneMissingIds: shouldPrune,
    );
  }
}
