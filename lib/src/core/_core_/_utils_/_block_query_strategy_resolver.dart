part of '../core.dart';

/// Centralized strategy resolver calculating execution plans and target ID sets
/// for a [Block] based on its current [BlockDataState], query mode, UI context,
/// and pipeline execution hints.
class BlockQueryStrategyResolver {
  /// Resolves the exact query execution plan for a given [block].
  static BlockQueryPlan<ID> resolveQueryPlan<ID extends Comparable>({
    required Block<
            ID, //
            Identifiable<ID>,
            Identifiable<ID>,
            FilterInput,
            FilterCriteria,
            FormInput,
            AdditionalFormRelatedData>
        block,
    required DebugBlockSyncSessionState<ID>? syncSessionState,
    required QueryHint queryHint,
    required bool provideBlockContext,
  }) {
    return resolveQueryPlanInternal<ID>(
      dataState: block.dataState,
      nativeQueryMode: block.config.nativeQueryMode,
      itemIds: block.items.map((i) => i.id).toList(),
      config: block.effectiveConfig,
      syncSessionState: syncSessionState,
      queryHint: queryHint,
      provideBlockContext: provideBlockContext,
    );
  }

  /// Resolves the exact query execution plan using explicit runtime parameters.
  static BlockQueryPlan<ID> resolveQueryPlanInternal<ID extends Comparable>({
    required BlockDataState dataState,
    required BlockNativeQueryMode nativeQueryMode,
    required List<ID> itemIds,
    required BlockEffectiveConfig config,
    required DebugBlockSyncSessionState<ID>? syncSessionState,
    required QueryHint queryHint,
    required bool provideBlockContext,
  }) {
    // -------------------------------------------------------------------------
    // 1. UNINITIALIZED STATE (BlockDataStateNone): Skip execution
    // -------------------------------------------------------------------------
    if (dataState.isNone) {
      return const BlockQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 2. EVALUATE EFFECTIVE FORCE RE-QUERY DEMAND
    // -------------------------------------------------------------------------
    // Re-query is required IF:
    // a. Pipeline explicitly mandated force (queryHint == QueryHint.force)
    // b. Active UI representation is visible AND dataset is unready (pending/stale)
    final bool effectiveForce = queryHint == QueryHint.force ||
        (provideBlockContext && (dataState.isPending || dataState.isStale));

    // If there is no demand to execute or refresh, reject execution immediately
    if (!effectiveForce) {
      return const BlockQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 3. EXPLICIT FETCH / COLD QUERY (syncSessionState == null)
    // -------------------------------------------------------------------------
    // If no sync session state is attached, this operation is not driven by
    // accumulated background events. Default directly to standard nativeQuery.
    if (syncSessionState == null) {
      return const BlockQueryPlan(
        action: BlockResolvedQueryAction.performQuery,
        viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
      );
    }

    final BlockViewportSyncConfig syncConfig = config.viewportSyncConfig;

    // -------------------------------------------------------------------------
    // 4. PENDING STATE (Cold Query with Prior Accumulated Events)
    // -------------------------------------------------------------------------
    if (dataState.isPending) {
      // Unbounded Flat Mode: Full Native Query is mandatory to establish baseline
      if (nativeQueryMode == BlockNativeQueryMode.fullQuery) {
        return const BlockQueryPlan(
          action: BlockResolvedQueryAction.performQuery,
          viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
        );
      }

      // Bounded Paginated Mode (pageableQuery):
      final Set<ID> accumulatedEffectedIds =
          syncSessionState.getEffectedItemIds();

      if (accumulatedEffectedIds.isEmpty) {
        // No pending mutated IDs: Sweep initial page (Page 1)
        return const BlockQueryPlan(
          action: BlockResolvedQueryAction.performQuery,
          viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
        );
      } else {
        // Mutated IDs present: Perform targeted ID query to preserve off-page items
        return BlockQueryPlan(
          action: BlockResolvedQueryAction.performQueryByItemIds,
          viewportSyncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          targetItemIds: accumulatedEffectedIds,
        );
      }
    }

    // -------------------------------------------------------------------------
    // 5. LOADED STATE (Event-Driven Re-query / Viewport Reconcile)
    // -------------------------------------------------------------------------
    if (dataState.isLoaded) {
      final List<BlockReceivedEventInfo<ID>> receivedEvents =
          syncSessionState.receivedEventInfos;

      // Resolve final strategy using block's viewportSyncConfig
      final BlockViewportSyncStrategy? resolvedStrategy =
          BlockViewportSyncStrategy.resolveViewportSyncStrategy(
        nativeQueryMode: nativeQueryMode,
        syncConfig: syncConfig,
        receivedEventInfos: receivedEvents,
      );

      switch (resolvedStrategy) {
        case null:
        case BlockViewportSyncStrategy.nativeQuery:
          return const BlockQueryPlan(
            action: BlockResolvedQueryAction.performQuery,
            viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
          );

        case BlockViewportSyncStrategy.effectedItemIdsQuery:
          final Set<ID> effectedIds = syncSessionState.getEffectedItemIds();

          // Safeguard: If no specific IDs were affected, do NOT destroy the viewport
          // by falling back to performQuery. Maintain current viewport intact.
          if (effectedIds.isEmpty) {
            return const BlockQueryPlan.none();
          }

          return BlockQueryPlan(
            action: BlockResolvedQueryAction.performQueryByItemIds,
            viewportSyncStrategy:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            targetItemIds: effectedIds,
          );

        case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
          final List<ID> currentBlockItemIds = itemIds;

          final Set<ID> performQueryIds =
              syncSessionState.getPerformQueryItemIds(currentBlockItemIds);

          // Fallback to full query if target ID pool resolves empty
          if (performQueryIds.isEmpty) {
            return const BlockQueryPlan(
              action: BlockResolvedQueryAction.performQuery,
              viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
            );
          }

          return BlockQueryPlan(
            action: BlockResolvedQueryAction.performQueryByItemIds,
            viewportSyncStrategy:
                BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
            targetItemIds: performQueryIds,
          );
      }
    }

    return const BlockQueryPlan.none();
  }
}
