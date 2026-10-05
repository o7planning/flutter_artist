import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockViewportSyncStrategy.resolveViewportSyncStrategy (Batch Mode) -',
      () {
    // Helper function to build test events quickly
    BlockReceivedEventInfo<String> createMockEvent({
      required EventSourceType type,
      BlockViewportSyncStrategy? fullQueryIntent,
      BlockViewportSyncStrategy? pageableQueryIntent,
      bool requiresMax = false,
    }) {
      return BlockReceivedEventInfo<String>(
        eventSourceType: type,
        syncStrategyOnFullQueryMode: fullQueryIntent,
        syncStrategyOnPageableQueryMode: pageableQueryIntent,
        dataTypes: [String],
        effectedItemIds: requiresMax ? [] : ['ID-1'],
        // extraDataTypes: [],
        requiresMaxSyncStrategy: requiresMax,
      );
    }

    // =========================================================================
    // 1. TEST SUITE: EMPTY BOUNDARY GUARD
    // =========================================================================
    group('Edge Case: Empty Event List -', () {
      test(
          'Should smoothly fallback directly to Floor when no events were accumulated',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
          minStrategyOnPageableQueryMode:
              BlockViewportSyncStrategy.effectedItemIdsQuery,
        );

        final fullQueryResolved =
            BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          syncConfig: syncConfig,
          receivedEventInfos: [],
        );

        final pageableResolved =
            BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          syncConfig: syncConfig,
          receivedEventInfos: [],
        );

        expect(
            fullQueryResolved, equals(BlockViewportSyncStrategy.nativeQuery));
        expect(pageableResolved,
            equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      });
    });

    // =========================================================================
    // 2. TEST SUITE: FULL QUERY MODE (Unbounded Flat Mode Rules)
    // Hierarchy: nativeQuery (3) > effectedAndViewportItemIdsQuery (2) > effectedItemIdsQuery (1) > null (0)
    // =========================================================================
    group('Under BlockNativeQueryMode.fullQuery -', () {
      const syncConfig = BlockViewportSyncConfig(
        minStrategyOnFullQueryMode:
            BlockViewportSyncStrategy.effectedItemIdsQuery, // Floor weight = 1
      );

      test(
          'Should force absolute nativeQuery sweep if any event carries requiresMaxSyncStrategy',
          () {
        final events = [
          createMockEvent(
              type: EventSourceType.internal,
              fullQueryIntent: BlockViewportSyncStrategy.effectedItemIdsQuery),
          createMockEvent(
              type: EventSourceType.external,
              requiresMax: true), // Storage Action with missing IDs
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          syncConfig: syncConfig,
          receivedEventInfos: events,
        );

        // Expected: Highest entity authority under fullQuery mode
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });

      test(
          'Should correctly pick the supreme maximum weight entry from multiple mixed events',
          () {
        final events = [
          createMockEvent(
              type: EventSourceType.internal,
              fullQueryIntent: BlockViewportSyncStrategy.effectedItemIdsQuery),
          // Weight 1
          createMockEvent(
              type: EventSourceType.external, fullQueryIntent: null),
          // Weight 0
          createMockEvent(
              type: EventSourceType.external,
              fullQueryIntent:
                  BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery),
          // Weight 2 (MAX)
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          syncConfig: syncConfig,
          receivedEventInfos: events,
        );

        // Expected: Weight 2 passes through Floor weight 1 safely
        expect(resolved,
            equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      });

      test(
          'Should auto-upgrade to Floor if the maximum extracted event intent is too weak',
          () {
        const strictConfig = BlockViewportSyncConfig(
          minStrategyOnFullQueryMode:
              BlockViewportSyncStrategy.nativeQuery, // Floor weight = 3
        );

        final events = [
          createMockEvent(
              type: EventSourceType.internal,
              fullQueryIntent: BlockViewportSyncStrategy.effectedItemIdsQuery),
          // Weight 1
          createMockEvent(
              type: EventSourceType.external,
              fullQueryIntent:
                  BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery),
          // Weight 2
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          syncConfig: strictConfig,
          receivedEventInfos: events,
        );

        // Expected: Max requested is 2, which is below Floor 3 -> Auto-upgraded to nativeQuery
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });
    });

    // =========================================================================
    // 3. TEST SUITE: PAGEABLE QUERY MODE (Bounded Paginated Mode Rules)
    // Hierarchy: effectedAndViewportItemIdsQuery (3) > effectedItemIdsQuery (2) > nativeQuery (1) > null (0)
    // =========================================================================
    group('Under BlockNativeQueryMode.pageableQuery -', () {
      const syncConfig = BlockViewportSyncConfig(
        minStrategyOnPageableQueryMode:
            BlockViewportSyncStrategy.effectedItemIdsQuery, // Floor weight = 2
      );

      test(
          'Should force full screen convergence if any event carries requiresMaxSyncStrategy',
          () {
        final events = [
          createMockEvent(
              type: EventSourceType.internal,
              pageableQueryIntent: BlockViewportSyncStrategy.nativeQuery),
          createMockEvent(
              type: EventSourceType.external,
              requiresMax: true), // Triggered by a blind global action
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          syncConfig: syncConfig,
          receivedEventInfos: events,
        );

        // Expected: Highest structural authority under pagination mode
        expect(resolved,
            equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      });

      test(
          'Should correctly isolate and elect the maximum weight entry from multiple mixed pagination intents',
          () {
        final events = [
          createMockEvent(
              type: EventSourceType.internal,
              pageableQueryIntent: BlockViewportSyncStrategy.nativeQuery),
          // Weight 1
          createMockEvent(
              type: EventSourceType.external, pageableQueryIntent: null),
          // Weight 0
          createMockEvent(
              type: EventSourceType.internal,
              pageableQueryIntent:
                  BlockViewportSyncStrategy.effectedItemIdsQuery),
          // Weight 2
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          syncConfig: syncConfig,
          receivedEventInfos: events,
        );

        // Expected: Weight 2 matches Floor weight 2 perfectly, allowing incremental merge
        expect(
            resolved, equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      });

      test(
          'Ceiling Guard: Should downgrade raw nativeQuery to convergence to protect the active pagination viewport',
          () {
        const standardConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Floor weight = 2
        );

        final events = [
          createMockEvent(
              type: EventSourceType.internal, pageableQueryIntent: null),
          createMockEvent(
              type: EventSourceType.external,
              pageableQueryIntent: BlockViewportSyncStrategy.nativeQuery),
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          syncConfig: standardConfig,
          receivedEventInfos: events,
        );

        expect(
            resolved, equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      });

      test(
          'Ceiling Exception: Should preserve nativeQuery if the Floor specifically demands that level of raw exposure',
          () {
        const extremeConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy.nativeQuery,
        );

        final events = [
          // The floor itself forces nativeQuery, overriding standard protective ceilings
          createMockEvent(
              type: EventSourceType.internal,
              pageableQueryIntent: BlockViewportSyncStrategy.nativeQuery),
        ];

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          syncConfig: extremeConfig,
          receivedEventInfos: events,
        );

        // Expected: Allowed to slip through because floor == nativeQuery
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });
    });
  });
}
