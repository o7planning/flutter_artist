import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/block_native_query_mode.dart';
import 'package:test/test.dart';

void main() {
  group('BlockViewportSyncStrategy.resolveViewportSyncStrategy -', () {
    // =========================================================================
    // 1. TEST SUITE: FULL QUERY MODE (Unbounded Flat Mode)
    // Priority: nativeQuery (3) > effectedAndViewportItemIdsQuery (2) > effectedItemIdsQuery (1) > null (0)
    // =========================================================================
    group('Under BlockNativeQueryMode.fullQuery (Flat Mode Rules) -', () {
      test(
          'Should smoothly auto-upgrade to Floor when backend intents are null',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          backendIntentInFullQueryMode: null, // Null is weight 0
          backendIntentInPageableQueryMode: null,
          syncConfig: syncConfig,
        );

        // Expected: Upgraded to Floor (nativeQuery)
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });

      test('Should allow stronger requested intents to pass through the Floor',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnFullQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Floor (Weight 1)
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          backendIntentInFullQueryMode: BlockViewportSyncStrategy.nativeQuery,
          // Requested (Weight 3)
          backendIntentInPageableQueryMode: null,
          syncConfig: syncConfig,
        );

        // Expected: nativeQuery (3) >= Floor (1), so nativeQuery is permitted
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });

      test(
          'Should force auto-upgrade when requested intent is weaker than configured Floor',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnFullQueryMode: BlockViewportSyncStrategy
              .effectedAndViewportItemIdsQuery, // Floor (Weight 2)
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.fullQuery,
          backendIntentInFullQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Requested (Weight 1)
          backendIntentInPageableQueryMode: null,
          syncConfig: syncConfig,
        );

        // Expected: Requested (1) < Floor (2), so it is auto-upgraded to the Floor
        expect(resolved,
            equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      });
    });

    // =========================================================================
    // 2. TEST SUITE: PAGEABLE QUERY MODE (Bounded Paginated Mode)
    // Priority: effectedAndViewportItemIdsQuery (3) > effectedItemIdsQuery (2) > nativeQuery (1) > null (0)
    // =========================================================================
    group('Under BlockNativeQueryMode.pageableQuery (Paginated Mode Rules) -',
        () {
      test(
          'Should smoothly auto-upgrade to Floor when backend intents are null',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode:
              BlockViewportSyncStrategy.effectedItemIdsQuery,
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          backendIntentInFullQueryMode: null,
          backendIntentInPageableQueryMode: null, // Null is weight 0
          syncConfig: syncConfig,
        );

        // Expected: Upgraded to Floor (effectedItemIdsQuery)
        expect(
            resolved, equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      });

      test('Should allow stronger requested intents to pass through the Floor',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Floor (Weight 2)
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          backendIntentInFullQueryMode: null,
          backendIntentInPageableQueryMode: BlockViewportSyncStrategy
              .effectedAndViewportItemIdsQuery, // Requested (Weight 3)
          syncConfig: syncConfig,
        );

        // Expected: Requested (3) >= Floor (2), so permitted
        expect(resolved,
            equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      });

      test(
          'Should force auto-upgrade when requested intent is weaker than configured Floor',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Floor (Weight 2)
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          backendIntentInFullQueryMode: null,
          backendIntentInPageableQueryMode:
              BlockViewportSyncStrategy.nativeQuery, // Requested (Weight 1)
          syncConfig: syncConfig,
        );

        // Expected: Requested (1) < Floor (2), so upgraded to Floor
        expect(
            resolved, equals(BlockViewportSyncStrategy.effectedItemIdsQuery));
      });

      test(
          'Ceiling Guard: Should downgrade nativeQuery to convergence to protect the active pagination viewport',
          () {
        const syncConfig = BlockViewportSyncConfig(
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy
              .effectedItemIdsQuery, // Floor (Weight 2)
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          backendIntentInFullQueryMode: null,
          // Action explicitly requests a raw native query on a paginated list
          backendIntentInPageableQueryMode:
              BlockViewportSyncStrategy.nativeQuery,
          syncConfig: syncConfig,
        );

        // Expected: Since floor is effectedItemIdsQuery (not nativeQuery),
        // the ceiling guard downclasses the raw nativeQuery to effectedAndViewportItemIdsQuery
        expect(resolved,
            equals(BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery));
      });

      test(
          'Ceiling Exception: Should permit nativeQuery if the Floor itself explicitly demands it',
          () {
        const syncConfig = BlockViewportSyncConfig(
          // Floor is extreme and strictly requires nativeQuery
          minStrategyOnPageableQueryMode: BlockViewportSyncStrategy.nativeQuery,
        );

        final resolved = BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
          nativeQueryMode: BlockNativeQueryMode.pageableQuery,
          backendIntentInFullQueryMode: null,
          backendIntentInPageableQueryMode:
              BlockViewportSyncStrategy.nativeQuery,
          syncConfig: syncConfig,
        );

        // Expected: Permitted because the Floor baseline explicitly matches nativeQuery
        expect(resolved, equals(BlockViewportSyncStrategy.nativeQuery));
      });
    });
  });
}
