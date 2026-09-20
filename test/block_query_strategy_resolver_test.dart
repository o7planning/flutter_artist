import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/qry_hint.dart';
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
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, isNull);
          expect(plan.viewportSyncStrategy, isNull);
          expect(plan.targetItemIds, isEmpty);
        });

    // -------------------------------------------------------------------------
    // TEST 2: Cold Pending in fullQuery Mode
    // -------------------------------------------------------------------------
    test(
        '2. Cold PENDING under fullQuery mode with UI visible MUST resolve to performQuery (nativeQuery)',
            () {
          final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
            dataState: const BlockDataStatePending(),
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.none,
            provideBlockContext: true, // Visible UI escalates pending state to query
          );

          expect(plan.action, equals(BlockResolvedQueryAction.performQuery));
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
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, equals(BlockResolvedQueryAction.performQuery));
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
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(
              plan.action, equals(BlockResolvedQueryAction.performQueryByItemIds));
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
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, equals(BlockResolvedQueryAction.performQuery));
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
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const ['333-beer', 'heineken-beer', 'tiger-beer'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, equals(BlockResolvedQueryAction.performQuery));
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
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const ['item-1', 'item-2'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.lenient(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(
              plan.action, equals(BlockResolvedQueryAction.performQueryByItemIds));
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
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const ['page2-item1', 'page2-item2'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(
              plan.action, equals(BlockResolvedQueryAction.performQueryByItemIds));
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
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const ['user-1'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.none,
            provideBlockContext: true,
          );

          expect(plan.action, isNull);
          expect(plan.viewportSyncStrategy, isNull);
        });

    // -------------------------------------------------------------------------
    // TEST 9: Empty Effected IDs with effectedItemIdsQuery (Config 2 - Viewport Safeguard)
    // -------------------------------------------------------------------------
    test(
        '9. [CONFIG 2] Warm LOADED STALE under effectedItemIdsQuery with EMPTY effected IDs MUST resolve to NULL (Preserve Viewport)',
            () {
          final mockSession = TestSyncSession<String>(
            receivedEventInfos: [
              BlockReceivedEventInfo<String>(
                eventSourceType: EventSourceType.special,
                requiresMaxSyncStrategy: false,
                syncStrategyOnFullQueryMode: null,
                syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedItemIdsQuery,
                dataTypes: const [],
                effectedItemIds: const [],
              ),
            ],
          );

          final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
            dataState: const BlockDataStateLoadedStale(
                reason: BlockLoadedStateStaleReason.event),
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const ['prod-1', 'prod-2', 'prod-3'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, isNull);
          expect(plan.viewportSyncStrategy, isNull);
          expect(plan.targetItemIds, isEmpty);
        });

    // -------------------------------------------------------------------------
    // TEST 10: Empty Effected IDs with effectedAndViewportItemIdsQuery (Config 3)
    // -------------------------------------------------------------------------
    test(
        '10. [CONFIG 3] Warm LOADED STALE under effectedAndViewportItemIdsQuery with EMPTY effected IDs MUST still query active viewport rows',
            () {
          final mockSession = TestSyncSession<String>(
            receivedEventInfos: [
              BlockReceivedEventInfo<String>(
                eventSourceType: EventSourceType.special,
                requiresMaxSyncStrategy: false,
                syncStrategyOnFullQueryMode: null,
                syncStrategyOnPageableQueryMode:
                BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
                dataTypes: const [],
                effectedItemIds: const [],
              ),
            ],
          );

          final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
            dataState: const BlockDataStateLoadedStale(
                reason: BlockLoadedStateStaleReason.event),
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const ['prod-1', 'prod-2', 'prod-3'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig(),
              ),
            ),
            syncSessionState: mockSession,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(
              plan.action, equals(BlockResolvedQueryAction.performQueryByItemIds));
          expect(plan.viewportSyncStrategy,
              equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
          expect(plan.targetItemIds, equals({'prod-1', 'prod-2', 'prod-3'}));
        });

    // -------------------------------------------------------------------------
    // TEST 11: Manual Stale State without Active Session
    // -------------------------------------------------------------------------
    test(
        '11. Warm LOADED STALE without syncSessionState (explicit manual stale) MUST fallback to performQuery (nativeQuery)',
            () {
          final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
            dataState: const BlockDataStateLoadedStale(
                reason: BlockLoadedStateStaleReason.event),
            nativeQueryMode: BlockNativeQueryMode.pageableQuery,
            itemIds: const ['item-1'],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.pageableQuery,
                viewportSyncConfig: BlockViewportSyncConfig(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.force,
            provideBlockContext: true,
          );

          expect(plan.action, equals(BlockResolvedQueryAction.performQuery));
          expect(plan.viewportSyncStrategy,
              equals(BlockViewportSyncStrategy.nativeQuery));
        });

    // -------------------------------------------------------------------------
    // TEST 12: Hidden UI (provideBlockContext == false) and queryHint == none
    // -------------------------------------------------------------------------
    test(
        '12. Hidden UI (provideBlockContext == false) and no force hint MUST resolve to NULL even if dataState is PENDING or STALE',
            () {
          final plan = BlockQueryStrategyResolver.resolveQueryPlanInternal<String>(
            dataState: const BlockDataStatePending(),
            nativeQueryMode: BlockNativeQueryMode.fullQuery,
            itemIds: const [],
            config: BlockEffectiveConfig.fromConfig(
              BlockConfig(
                nativeQueryMode: BlockNativeQueryMode.fullQuery,
                viewportSyncConfig: BlockViewportSyncConfig.strict(),
              ),
            ),
            syncSessionState: null,
            queryHint: QryHint.none,
            provideBlockContext: false, // Off-screen / hidden UI -> No query needed!
          );

          expect(plan.action, isNull);
          expect(plan.viewportSyncStrategy, isNull);
        });
  });
}

// =============================================================================
// LIGHTWEIGHT TEST STUB FOR SESSION STATE
// =============================================================================

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