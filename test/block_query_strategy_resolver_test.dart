import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockQueryStrategyResolver.resolveQueryPlanInternal Unit Tests', () {
    // -------------------------------------------------------------------------
    // TEST 1: Uninitialized State (BlockDataStateNone)
    // -------------------------------------------------------------------------
    test(
        '1. Should resolve to NULL action plan when dataState is BlockDataStateNone',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStateNone(),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
      );

      expect(plan.action, isNull);
      expect(plan.viewportSyncStrategy, isNull);
      expect(plan.targetItemIds, isEmpty);
    });

    // -------------------------------------------------------------------------
    // TEST 2: Cold Pending in fullQuery Mode
    // -------------------------------------------------------------------------
    test(
        '2. Cold PENDING under fullQuery mode MUST always resolve to performQuery (nativeQuery)',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStatePending(),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
      expect(plan.targetItemIds, isEmpty);
    });

    // -------------------------------------------------------------------------
    // TEST 3: Cold Pending in pageableQuery Mode
    // -------------------------------------------------------------------------
    test(
        '3a. Cold PENDING under pageableQuery without effected IDs resolves to performQuery (Page 1)',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStatePending(),
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig(),
        ),
        syncSessionState: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
    });

    test(
        '3b. Cold PENDING under pageableQuery WITH accumulated effected IDs resolves to performQueryByItemIds',
        () {
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>(
            eventSourceType: EventSourceType.external,
            requiresMaxSyncStrategy: false,
            syncStrategyOnFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
            syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            dataTypes: const [],
            effectedItemIds: const ['user-10', 'user-20'],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStatePending(),
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig(),
        ),
        syncSessionState: mockSession,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      expect(plan.targetItemIds, containsAll(['user-10', 'user-20']));
    });

    // -------------------------------------------------------------------------
    // TEST 4: PENDING State with Previous Error / Retry
    // -------------------------------------------------------------------------
    test(
        '4. PENDING state after a failed query attempt still resolves as standard PENDING',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStatePending(
          reason: BlockPendingReasonFailed(
            errorOrigin: BlockErrorOrigin.directFetch,
            errorInfo: null,
          ),
        ),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
    });

    // -------------------------------------------------------------------------
    // TEST 5: Warm LOADED STALE in fullQuery Mode under STRICT Config (Scenario 83b)
    // -------------------------------------------------------------------------
    test(
        '5. [SCENARIO 83b] Warm LOADED STALE under fullQuery + STRICT config MUST resolve to performQuery (nativeQuery)',
        () {
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>.maxSyncStrategy(
            eventSourceType: EventSourceType.external,
            dataTypes: const [],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReason.event),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const ['333-beer', 'heineken-beer', 'tiger-beer'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .strict(), // Strict floor on fullQuery = nativeQuery
        ),
        syncSessionState: mockSession,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
      expect(plan.targetItemIds, isEmpty);
    });

    // -------------------------------------------------------------------------
    // TEST 6: Warm LOADED STALE in fullQuery Mode under LENIENT Config
    // -------------------------------------------------------------------------
    test(
        '6. Warm LOADED STALE under fullQuery + LENIENT config permits localized performQueryByItemIds if explicit IDs present',
        () {
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>(
            eventSourceType: EventSourceType.external,
            requiresMaxSyncStrategy: false,
            syncStrategyOnFullQueryMode:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            dataTypes: const [],
            effectedItemIds: const ['item-99'],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReason.event),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const ['item-1', 'item-2'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .lenient(), // Lenient floor on fullQuery = effectedItemIdsQuery
        ),
        syncSessionState: mockSession,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      expect(plan.targetItemIds, equals({'item-99'}));
    });

    // -------------------------------------------------------------------------
    // TEST 7: Warm LOADED STALE in pageableQuery Mode under STRICT Config
    // -------------------------------------------------------------------------
    test(
        '7. Warm LOADED STALE under pageableQuery + STRICT config forces effectedAndViewportItemIdsQuery',
        () {
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>(
            eventSourceType: EventSourceType.external,
            requiresMaxSyncStrategy: false,
            syncStrategyOnFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
            syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
            dataTypes: const [],
            effectedItemIds: const ['new-created-item'],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReason.event),
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        itemIds: const ['page2-item1', 'page2-item2'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .strict(), // Strict floor on pageable = effectedAndViewport
        ),
        syncSessionState: mockSession,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      expect(plan.targetItemIds,
          containsAll(['page2-item1', 'page2-item2', 'new-created-item']));
    });

    // -------------------------------------------------------------------------
    // TEST 8: Clean LOADED FRESH State (No Stale, No Session)
    // -------------------------------------------------------------------------
    test(
        '8. Clean LOADED FRESH block without session resolves to NULL action plan',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: const BlockDataStateLoadedFresh(),
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        itemIds: const ['user-1'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
      );

      expect(plan.action, isNull);
      expect(plan.viewportSyncStrategy, isNull);
    });
  });
}

// =============================================================================
// LIGHTWEIGHT TEST STUB FOR SESSION STATE
// =============================================================================

/// A lightweight, standalone implementation of [DebugBlockSyncSessionState] for pure unit tests.
class TestSyncSession<ID extends Comparable>
    implements DebugBlockSyncSessionState<ID> {
  @override
  final Comparable? parentBlockItemId;

  @override
  final FilterCriteria? filterCriteria;

  @override
  final List<BlockReceivedEventInfo<ID>> receivedEventInfos;

  TestSyncSession({
    this.parentBlockItemId,
    this.filterCriteria,
    this.receivedEventInfos = const [],
  });

  @override
  Set<ID> getEffectedItemIds() {
    final Set<ID> set = {};
    for (final info in receivedEventInfos) {
      set.addAll(info.effectedItemIds);
    }
    return set;
  }

  @override
  Set<ID> getPerformQueryItemIds(List<ID> blockItemIds) {
    final effected = getEffectedItemIds();
    return {...blockItemIds, ...effected};
  }

  @override
  Block<
      ID,
      Identifiable<ID>,
      Identifiable<ID>,
      FilterInput,
      FilterCriteria,
      FormInput,
      AdditionalFormRelatedData> get block => throw UnimplementedError();
}
