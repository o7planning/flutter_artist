import '../../enums/action_result_state.dart';
import '../../enums/error_origin.dart';
import '../../enums/fallback_dilemma_strategy.dart';
import '../../error/_scalar_error_info.dart';
import '../core.dart';

/// Immutable parameter blueprint feeding into the scalar state calculator engine.
class ScalarQueryCalculatorInput {
  /// The resulting outcome of the active remote data fetch cycle.
  final ActionResultState queryResultState;

  /// Identifies the architectural source/trigger of the failure, or null if no error occurred.
  final ScalarErrorOrigin? scalarErrorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if any.
  final ScalarErrorInfo? scalarErrorInfo;

  /// The current state ledger bound to the active runtime scalar model.
  final ScalarDataState currentDataState;

  /// Criteria shift flag indicating whether search criteria or filter inputs mutated for this query.
  final bool filterCriteriaChanged;

  /// Flag indicating whether this query was triggered by background polling or a non-blocking timer.
  final bool isBackgroundPolling;

  /// The explicit rule dictating how to resolve cached data when query operations fail.
  final FallbackDilemmaStrategy dilemmaStrategy;

  const ScalarQueryCalculatorInput({
    required this.queryResultState,
    required this.scalarErrorOrigin,
    required this.scalarErrorInfo,
    required this.currentDataState,
    required this.filterCriteriaChanged,
    this.isBackgroundPolling = false,
    this.dilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache,
  });

  String getDebugInfo() {
    return "--------- ScalarQueryCalculatorInput -------------- \n"
        "   - scalarErrorOrigin: $scalarErrorOrigin \n"
        "   - scalarErrorInfo: $scalarErrorInfo \n"
        "   - currentDataState: $currentDataState \n"
        "   - filterCriteriaChanged: $filterCriteriaChanged \n"
        "   - isBackgroundPolling: $isBackgroundPolling \n"
        "   - dilemmaStrategy: $dilemmaStrategy \n";
  }
}

/// Consolidated execution blueprint resolved by the scalar calculator matrix.
class ScalarQueryCalculatorResult {
  /// The next structural lifecycle state target assigned onto the running scalar model.
  final ScalarDataState newScalarDataState;

  const ScalarQueryCalculatorResult({
    required this.newScalarDataState,
  });

  String getDebugInfo() {
    return "--------- ScalarQueryCalculatorResult -------------- \n"
        "   - newScalarDataState: $newScalarDataState \n";
  }
}

class ScalarQueryStateCalculator {
  /// Pure mathematical evaluation matrix resolving scalar lifecycle states safely.
  ///
  /// Guarantees absolute isolation, making state modifications completely side-effect free.
  static ScalarQueryCalculatorResult calculate(
      ScalarQueryCalculatorInput input) {
    ScalarDataState resolvedState;

    // =========================================================================
    // 🛑 BRANCH 1: REMOTE QUERY LIFECYCLE FAILED
    // =========================================================================
    if (input.queryResultState == ActionResultState.fail) {
      final effectiveOrigin =
          input.scalarErrorOrigin ?? ScalarErrorOrigin.directFetch;

      // Case 1.1: Criteria mutated (Search/Filter changed)
      if (input.filterCriteriaChanged) {
        if (input.currentDataState.isLoaded &&
            input.dilemmaStrategy ==
                FallbackDilemmaStrategy.preserveStableCache) {
          // Preserve previous scalar metric on screen, mark as STALE due to criteria mismatch
          resolvedState = ScalarDataStateLoadedStale(
            reason: ScalarLoadedStateStaleReasonFailed(
              errorOrigin: effectiveOrigin,
              errorInfo: input.scalarErrorInfo,
            ),
          );
        } else {
          // Hard eviction or cold baseline failure -> Fallback to cold PENDING
          resolvedState = ScalarDataStatePending.failed(
            errorOrigin: effectiveOrigin,
            errorInfo: input.scalarErrorInfo,
          );
        }
      }
      // Case 1.2: Criteria preserved -> Evaluate based on previous structural stability
      else {
        if (input.currentDataState.isLoaded) {
          // Background polling failure retains current metric freshness while attaching transient error
          if (input.isBackgroundPolling) {
            resolvedState = input.currentDataState.isStale
                ? input.currentDataState
                : ScalarDataStateLoadedFresh(
                    transientErrorInfo: input.scalarErrorInfo,
                  );
          } else {
            // Explicit root refresh failure evaluates fallback dilemma policy
            if (input.dilemmaStrategy ==
                FallbackDilemmaStrategy.evictStaleContent) {
              resolvedState = ScalarDataStatePending.failed(
                errorOrigin: effectiveOrigin,
                errorInfo: input.scalarErrorInfo,
              );
            } else {
              resolvedState = ScalarDataStateLoadedStale(
                reason: ScalarLoadedStateStaleReasonFailed(
                  errorOrigin: effectiveOrigin,
                  errorInfo: input.scalarErrorInfo,
                ),
              );
            }
          }
        } else {
          // Scalar was uninitialized or pending before the crash -> Stay in PENDING
          resolvedState = ScalarDataStatePending.failed(
            errorOrigin: effectiveOrigin,
            errorInfo: input.scalarErrorInfo,
          );
        }
      }
    }
    // =========================================================================
    // 🎉 BRANCH 2: REMOTE QUERY LIFECYCLE SUCCEEDED
    // =========================================================================
    else {
      // Successful remote sync mounts fresh loaded baseline data (clearing transient errors)
      resolvedState = const ScalarDataStateLoadedFresh();
    }

    return ScalarQueryCalculatorResult(
      newScalarDataState: resolvedState,
    );
  }

  /// Pure state calculator when an operational error occurs before executing queries
  /// (e.g., criteria extraction, filter evaluation, or parent cascade propagation).
  static ScalarDataState calculateDataStateOnError({
    required ScalarDataState currentDataState,
    required ScalarErrorOrigin scalarErrorOrigin,
    required ScalarErrorInfo? scalarErrorInfo,
    required FallbackDilemmaStrategy dilemmaStrategy,
  }) {
    // 1. If child scalar is in None state (parent has no active item context) -> Preserve None
    if (currentDataState.isNone) {
      return const ScalarDataStateNone();
    }

    // 2. If scalar is in Pending state -> Propagate failure to Pending.failed
    if (currentDataState.isPending) {
      return ScalarDataStatePending.failed(
        errorOrigin: scalarErrorOrigin,
        errorInfo: scalarErrorInfo,
      );
    }

    // 3. Loaded: evaluate fallback dilemma rule
    if (dilemmaStrategy == FallbackDilemmaStrategy.preserveStableCache) {
      return ScalarDataStateLoadedStale(
        reason: ScalarLoadedStateStaleReasonFailed(
          errorOrigin: scalarErrorOrigin,
          errorInfo: scalarErrorInfo,
        ),
      );
    }

    return ScalarDataStatePending.failed(
      errorOrigin: scalarErrorOrigin,
      errorInfo: scalarErrorInfo,
    );
  }
}
