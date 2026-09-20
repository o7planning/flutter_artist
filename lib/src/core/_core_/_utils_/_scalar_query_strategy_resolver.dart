part of '../core.dart';

/// Centralized strategy resolver calculating execution plans for a [Scalar]
/// based on its current [ScalarDataState], invalidation flags, UI context,
/// and pipeline execution hints.
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
    required QryHint queryHint,
    required bool provideScalarContext,
  }) {
    return resolveQueryPlanInternal<ID>(
      dataState: scalar.dataState,
      config: scalar.effectiveConfig,
      syncSessionState: syncSessionState,
      queryHint: queryHint,
      provideScalarContext: provideScalarContext,
    );
  }

  /// Resolves the exact query execution plan using explicit runtime parameters.
  static ScalarQueryPlan<ID> resolveQueryPlanInternal<ID extends Comparable>({
    required ScalarDataState dataState,
    required ScalarEffectiveConfig config,
    required DebugScalarSyncSessionState<ID>? syncSessionState,
    required QryHint queryHint,
    required bool provideScalarContext,
  }) {
    // -------------------------------------------------------------------------
    // 1. UNINITIALIZED STATE (ScalarDataStateNone): Skip execution
    // -------------------------------------------------------------------------
    if (dataState.isNone) {
      return const ScalarQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 2. EVALUATE EFFECTIVE FORCE RE-QUERY DEMAND
    // -------------------------------------------------------------------------
    // Re-query is required IF:
    // a. Pipeline explicitly mandated force (queryHint == QryHint.force)
    // b. Active UI component is visible AND data is unready (pending/stale)
    final bool effectiveForce = queryHint == QryHint.force ||
        (provideScalarContext && (dataState.isPending || dataState.isStale));

    // If there is no demand to execute or refresh, reject execution immediately
    if (!effectiveForce) {
      return const ScalarQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 3. EXPLICIT FETCH / COLD QUERY (syncSessionState == null)
    // -------------------------------------------------------------------------
    // If no sync session state is attached, this operation is not driven by
    // accumulated background events. Default directly to performQuery.
    if (syncSessionState == null) {
      return const ScalarQueryPlan(
        action: ScalarResolvedQueryAction.performQuery,
      );
    }

    // -------------------------------------------------------------------------
    // 4. PENDING STATE (Cold Query with Prior Accumulated Events)
    // -------------------------------------------------------------------------
    if (dataState.isPending) {
      return const ScalarQueryPlan(
        action: ScalarResolvedQueryAction.performQuery,
      );
    }

    // -------------------------------------------------------------------------
    // 5. LOADED STATE (Event-Driven Re-query / Metric Reconcile)
    // -------------------------------------------------------------------------
    if (dataState.isLoaded) {
      return const ScalarQueryPlan(
        action: ScalarResolvedQueryAction.performQuery,
      );
    }

    return const ScalarQueryPlan.none();
  }
}