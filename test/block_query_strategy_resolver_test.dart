import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockQueryStrategyResolver.resolveQueryPlanInternal Unit Tests', () {
    // -------------------------------------------------------------------------
    // TEST 1: Uninitialized State (DataState.none)
    // -------------------------------------------------------------------------
    test(
        '1. Should resolve to NULL action plan when dataState is DataState.none',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: DataState.none,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: false,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
        errorOrigin: null,
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
        dataState: DataState.pending,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: false,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
        errorOrigin: null,
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
        dataState: DataState.pending,
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        hasPendingInvalidation: false,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig(),
        ),
        syncSessionState: null,
        errorOrigin: null,
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
        dataState: DataState.pending,
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        hasPendingInvalidation: false,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig(),
        ),
        syncSessionState: mockSession,
        errorOrigin: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      expect(plan.targetItemIds, containsAll(['user-10', 'user-20']));
    });

    // -------------------------------------------------------------------------
    // TEST 4: Error State Origin Mapping
    // -------------------------------------------------------------------------
    test('4a. Error state originating from PENDING behaves as Cold PENDING',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: DataState.error,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: false,
        itemIds: const [],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
        errorOrigin: BlockErrorOrigin.fromPending,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
    });

    test('4b. Error state originating from READY behaves as Warm READY', () {
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>(
            eventSourceType: EventSourceType.external,
            requiresMaxSyncStrategy: false,
            syncStrategyOnFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
            syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
            dataTypes: const [],
            effectedItemIds: const ['user-3'],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: DataState.error,
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        hasPendingInvalidation: true,
        itemIds: const ['user-1', 'user-2'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig(),
        ),
        syncSessionState: mockSession,
        errorOrigin: BlockErrorOrigin.fromReady,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
    });

    // -------------------------------------------------------------------------
    // TEST 5: Warm READY in fullQuery Mode under STRICT Config (Scenario 83b)
    // -------------------------------------------------------------------------
    test(
        '5. [SCENARIO 83b] Warm READY under fullQuery + STRICT config MUST resolve to performQuery (nativeQuery)',
        () {
      // In Scenario 83b: fullQuery mode + strict() config + broadcast event requiring MAX SYNC
      final mockSession = TestSyncSession<String>(
        receivedEventInfos: [
          BlockReceivedEventInfo<String>.maxSyncStrategy(
            eventSourceType: EventSourceType.external,
            dataTypes: const [],
          ),
        ],
      );

      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: DataState.ready,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: true,
        itemIds: const ['333-beer', 'heineken-beer', 'tiger-beer'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .strict(), // Strict floor on fullQuery = nativeQuery
        ),
        syncSessionState: mockSession,
        errorOrigin: null,
      );

      // EXPECTATION: Must trigger full performQuery, NOT performQueryByItemIds!
      expect(plan.action, equals(ResolvedQueryAction.performQuery));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.nativeQuery));
      expect(plan.targetItemIds, isEmpty);
    });

    // -------------------------------------------------------------------------
    // TEST 6: Warm READY in fullQuery Mode under LENIENT Config
    // -------------------------------------------------------------------------
    test(
        '6. Warm READY under fullQuery + LENIENT config permits localized performQueryByItemIds if explicit IDs present',
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
        dataState: DataState.ready,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: true,
        itemIds: const ['item-1', 'item-2'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .lenient(), // Lenient floor on fullQuery = effectedItemIdsQuery
        ),
        syncSessionState: mockSession,
        errorOrigin: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      expect(plan.targetItemIds, equals({'item-99'}));
    });

    // -------------------------------------------------------------------------
    // TEST 7: Warm READY in pageableQuery Mode under STRICT Config
    // -------------------------------------------------------------------------
    test(
        '7. Warm READY under pageableQuery + STRICT config forces effectedAndViewportItemIdsQuery',
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
        dataState: DataState.ready,
        pendingNativeQueryMode: BlockNativeQueryMode.pageableQuery,
        hasPendingInvalidation: true,
        itemIds: const ['page2-item1', 'page2-item2'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          viewportSyncConfig: BlockViewportSyncConfig
              .strict(), // Strict floor on pageable = effectedAndViewport
        ),
        syncSessionState: mockSession,
        errorOrigin: null,
      );

      expect(plan.action, equals(ResolvedQueryAction.performQueryByItemIds));
      expect(plan.viewportSyncStrategy,
          equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      expect(plan.targetItemIds,
          containsAll(['page2-item1', 'page2-item2', 'new-created-item']));
    });

    // -------------------------------------------------------------------------
    // TEST 8: Clean READY State (No Invalidation, No Session)
    // -------------------------------------------------------------------------
    test(
        '8. Clean READY block without pending invalidation resolves to NULL action plan',
        () {
      final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
        dataState: DataState.ready,
        pendingNativeQueryMode: BlockNativeQueryMode.fullQuery,
        hasPendingInvalidation: false,
        itemIds: const ['user-1'],
        config: BlockConfig(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          viewportSyncConfig: BlockViewportSyncConfig.strict(),
        ),
        syncSessionState: null,
        errorOrigin: null,
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
