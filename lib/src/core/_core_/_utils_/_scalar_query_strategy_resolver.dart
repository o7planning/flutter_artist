part of '../core.dart';

/// Centralized strategy resolver calculating execution plans for a [Scalar]
/// based on its current [ScalarDataState], invalidation flags, and synchronization context.
class ScalarQueryStrategyResolver {
  /// Resolves the exact query execution plan for a given [scalar].
  static ScalarQueryPlan<ID> resolveQueryPlan<ID extends Comparable>({
    required Scalar<
        ID, //
        Identifiable<ID>,
        FilterInput,
        FilterCriteria>
    scalar,
    required DebugScalarSyncSessionState<ID>? syncSessionState,
  }) {
    return resolveQueryPlanInternal<ID>(
      dataState: scalar.dataState,
      config: scalar.effectiveConfig,
      syncSessionState: syncSessionState,
    );
  }

  /// Resolves the exact query execution plan using explicit runtime parameters.
  static ScalarQueryPlan<ID> resolveQueryPlanInternal<ID extends Comparable>({
    required ScalarDataState dataState,
    required ScalarEffectiveConfig config,
    required DebugScalarSyncSessionState<ID>? syncSessionState,
  }) {
    // -------------------------------------------------------------------------
    // 1. UNINITIALIZED STATE (ScalarDataStateNone): Skip execution
    // -------------------------------------------------------------------------
    if (dataState.isNone) {
      return const ScalarQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 2. PENDING STATE (Cold Query / Baseline Initialization)
    // -------------------------------------------------------------------------
    if (dataState.isPending) {
      return const ScalarQueryPlan(
        action: ScalarResolvedQueryAction.performQuery,
      );
    }

    // -------------------------------------------------------------------------
    // 3. LOADED STATE (Warm Re-query / Invalidation Reconcile)
    // -------------------------------------------------------------------------
    if (dataState.isLoaded) {
      final bool isStale = dataState.isStale;

      // If scalar is clean and has no pending invalidation or events, do nothing
      if (!isStale && syncSessionState == null) {
        return const ScalarQueryPlan.none();
      }

      // Re-fetch the scalar value when invalidation flags or external events are present
      return const ScalarQueryPlan(
        action: ScalarResolvedQueryAction.performQuery,
      );
    }

    return const ScalarQueryPlan.none();
  }
}
