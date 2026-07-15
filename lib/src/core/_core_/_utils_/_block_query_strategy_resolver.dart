part of '../core.dart';

/// Centralized strategy resolver calculating execution plans and target ID sets
/// for a [Block] based on its current data state, error origin, query mode,
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
    required BlockErrorOrigin? errorOrigin,
  }) {
    // print("TEMP 83b.1: block.dataState: ${block.dataState}");
    // print("TEMP 83b.2: block.pendingNativeQueryMode: ${block.pendingNativeQueryMode}");
    // print("TEMP 83b.3: block.hasPendingInvalidation: ${block.hasPendingInvalidation}");
    // print("TEMP 83b.4: block.itemIds: ${block.itemIds}");
    // print("TEMP 83b.5: block.config: ${block.config}");
    // print("TEMP 83b.6: syncSessionState: ${syncSessionState}");
    // print("TEMP 83b.7: errorOrigin: ${errorOrigin}");

    return resolveQueryPlanInternal<ID>(
      dataState: block.dataState,
      pendingNativeQueryMode: block.pendingNativeQueryMode,
      hasPendingInvalidation: block.hasPendingInvalidation,
      itemIds: block.itemIds,
      config: block.config,
      syncSessionState: syncSessionState,
      errorOrigin: errorOrigin,
    );
  }

  /// Resolves the exact query execution plan for a given [block].
  static BlockQueryPlan<ID> resolveQueryPlanInternal<ID extends Comparable>({
    required DataState dataState,
    required BlockNativeQueryMode pendingNativeQueryMode,
    required bool hasPendingInvalidation,
    required List<ID> itemIds,
    required BlockConfig config,
    required DebugBlockSyncSessionState<ID>? syncSessionState,
    required BlockErrorOrigin? errorOrigin,
  }) {
    // -------------------------------------------------------------------------
    // 1. UNINITIALIZED STATE (DataState.none): Skip execution
    // -------------------------------------------------------------------------
    if (dataState == DataState.none) {
      return const BlockQueryPlan.none();
    }

    // -------------------------------------------------------------------------
    // 2. EFFECTIVE STATE MAPPING (Mapping Error Origins)
    // -------------------------------------------------------------------------
    final bool isEffectivePending = dataState == DataState.pending ||
        (dataState == DataState.error &&
            errorOrigin == BlockErrorOrigin.fromPending);

    final bool isEffectiveReady = dataState == DataState.ready ||
        (dataState == DataState.error &&
            errorOrigin == BlockErrorOrigin.fromReady);

    final BlockViewportSyncConfig syncConfig = config.viewportSyncConfig;

    // -------------------------------------------------------------------------
    // CASE A: Effective PENDING State (Cold Query / Baseline Initialization)
    // -------------------------------------------------------------------------
    if (isEffectivePending) {
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
    // CASE B: Effective READY State (Warm Re-query / Invalidation Reconcile)
    // -------------------------------------------------------------------------
    if (isEffectiveReady) {
      // If block is clean and has no pending invalidation or events, do nothing
      if (!hasPendingInvalidation && syncSessionState == null) {
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
