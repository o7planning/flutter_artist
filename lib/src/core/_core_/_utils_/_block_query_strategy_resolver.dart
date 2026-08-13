part of '../core.dart';

/// Centralized strategy resolver calculating execution plans and target ID sets
/// for a [Block] based on its current [BlockDataState], query mode,
/// and boundary rules defined in [BlockViewportSyncConfig].
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
  }) {
    return resolveQueryPlanInternal<ID>(
      dataState: block.dataState,
      pendingNativeQueryMode: block.pendingNativeQueryMode,
      itemIds: block.items.map((i) => i.id).toList(),
      config: block.config,
      syncSessionState: syncSessionState,
    );
  }

  /// Resolves the exact query execution plan using explicit runtime parameters.
  static BlockQueryPlan<ID> resolveQueryPlanInternal<ID extends Comparable>({
    required BlockDataState dataState,
    required BlockNativeQueryMode pendingNativeQueryMode,
    required List<ID> itemIds,
    required BlockConfig config,
    required DebugBlockSyncSessionState<ID>? syncSessionState,
  }) {
    // -------------------------------------------------------------------------
    // 1. UNINITIALIZED STATE (BlockDataStateNone): Skip execution
    // -------------------------------------------------------------------------
    if (dataState.isNone) {
      return const BlockQueryPlan.none();
    }

    final BlockViewportSyncConfig syncConfig = config.viewportSyncConfig;

    // -------------------------------------------------------------------------
    // 2. PENDING STATE (Cold Query / Baseline Initialization)
    // -------------------------------------------------------------------------
    if (dataState.isPending) {
      // Unbounded Flat Mode: Full Native Query is mandatory to establish baseline
      if (config.nativeQueryMode == BlockNativeQueryMode.fullQuery) {
        return const BlockQueryPlan(
          action: ResolvedQueryAction.performQuery,
          viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
        );
      }

      // Bounded Paginated Mode (pageableQuery):
      final Set<ID> accumulatedEffectedIds =
          syncSessionState?.getEffectedItemIds() ?? const {};

      if (accumulatedEffectedIds.isEmpty) {
        // No pending mutated IDs: Sweep initial page (Page 1)
        return const BlockQueryPlan(
          action: ResolvedQueryAction.performQuery,
          viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
        );
      } else {
        // Mutated IDs present: Perform targeted ID query to preserve off-page items
        return BlockQueryPlan(
          action: ResolvedQueryAction.performQueryByItemIds,
          viewportSyncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          targetItemIds: accumulatedEffectedIds,
        );
      }
    }

    // -------------------------------------------------------------------------
    // 3. LOADED STATE (Warm Re-query / Invalidation Reconcile)
    // -------------------------------------------------------------------------
    if (dataState.isLoaded) {
      final bool isStale = dataState.isStale;

      // If block is clean and has no pending invalidation or events, do nothing
      if (!isStale && syncSessionState == null) {
        return const BlockQueryPlan.none();
      }

      final List<BlockReceivedEventInfo<ID>> receivedEvents =
          syncSessionState?.receivedEventInfos ?? const [];

      // Resolve final strategy using block's viewportSyncConfig
      final BlockViewportSyncStrategy? resolvedStrategy =
          BlockViewportSyncStrategy.resolveViewportSyncStrategy(
        nativeQueryMode: pendingNativeQueryMode,
        syncConfig: syncConfig,
        receivedEventInfos: receivedEvents,
      );

      switch (resolvedStrategy) {
        case null:
        case BlockViewportSyncStrategy.nativeQuery:
          return const BlockQueryPlan(
            action: ResolvedQueryAction.performQuery,
            viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
          );

        case BlockViewportSyncStrategy.effectedItemIdsQuery:
          final Set<ID> effectedIds =
              syncSessionState?.getEffectedItemIds() ?? const {};

          // Fallback to full native query if no specific item IDs exist
          if (effectedIds.isEmpty) {
            return const BlockQueryPlan(
              action: ResolvedQueryAction.performQuery,
              viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
            );
          }

          return BlockQueryPlan(
            action: ResolvedQueryAction.performQueryByItemIds,
            viewportSyncStrategy:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            targetItemIds: effectedIds,
          );

        case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
          final List<ID> currentBlockItemIds = itemIds;

          final Set<ID> performQueryIds =
              syncSessionState?.getPerformQueryItemIds(currentBlockItemIds) ??
                  currentBlockItemIds.toSet();

          // Fallback to full query if target ID pool resolves empty
          if (performQueryIds.isEmpty) {
            return const BlockQueryPlan(
              action: ResolvedQueryAction.performQuery,
              viewportSyncStrategy: BlockViewportSyncStrategy.nativeQuery,
            );
          }

          return BlockQueryPlan(
            action: ResolvedQueryAction.performQueryByItemIds,
            viewportSyncStrategy:
                BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
            targetItemIds: performQueryIds,
          );
      }
    }

    return const BlockQueryPlan.none();
  }
}
