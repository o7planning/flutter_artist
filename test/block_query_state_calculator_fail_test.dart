import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/block_query_state_calculator.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '🛡️ QueryStateCalculator - Failure Scenario Matrices (ActionResultState.fail)',
      () {
    // =========================================================================
    // BRANCH 1.1: CRITERIA BOUNDARY MUTATED (filterCriteriaChanged == true)
    // =========================================================================
    group('Branch 1.1 - Criteria Mutated (Filter Criteria Changed)', () {
      test(
          '1.1.1 - Should preserve cache as STALE when filter changes during failure under preserveStableCache',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy:
              BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          filterCriteriaChanged: true,
          // Criteria mutation active
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.replace,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        // Retains previous dataset on screen, but flags as STALE due to criteria mismatch
        expect(
          result.newBlockDataState,
          BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReasonFailed(errorInfo: null),
          ),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.refetchFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
        expect(result.forcePruneMissingIds, false);
      });

      test(
          '1.1.2 - Should evict and fallback to PENDING when filter changes during failure under evictStaleContent',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy:
              BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          filterCriteriaChanged: true,
          // Criteria mutation active
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
            reason: BlockPendingReasonFailed(
              errorOrigin: BlockErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
        expect(result.forcePruneMissingIds, false);
      });

      test(
          '1.1.3 - Cold baseline with mutated filter criteria MUST always fallback to PENDING on failure',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateNone(),
          // Cold uninitialized state
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: true,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
            reason: BlockPendingReasonFailed(
              errorOrigin: BlockErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });

      test(
          '1.1.4 - Criteria mutation takes priority over lazy load bounds on failure under preserveStableCache',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          filterCriteriaChanged: true,
          // Filter criteria shift overrides queryMore
          isQueryMore: true,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReasonFailed(errorInfo: null),
          ),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.refetchFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });
    });

    // =========================================================================
    // BRANCH 1.2: CRITERIA PRESERVED (filterCriteriaChanged == false)
    // =========================================================================
    group('Branch 1.2 - Criteria Stabilized (Filter Criteria Intact)', () {
      test(
          '1.2.1 - EAGER LOCAL PRUNING GATE: Should drop deleted item IDs immediately even if re-query fails',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: true,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.replace,
          hasRemoveItemIds: true,
          // Destructive operation footprint active
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        // Keeps valid rows on screen, marks stale due to reconciliation failure, flags for local prune
        expect(
          result.newBlockDataState,
          BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReasonFailed(errorInfo: null),
          ),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.mutationFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
        expect(result.forcePruneMissingIds, true); // Active local cache janitor
      });

      test(
          '1.2.2 - Should retain FRESH state and attach transientErrorInfo when page shifting or lazy loading under preserveStableCache rules',
          () {
        final flowTriggers = [
          {'queryMore': true, 'pageShift': false},
          {'queryMore': false, 'pageShift': true}
        ];

        for (var trigger in flowTriggers) {
          final input = BlockQueryCalculatorInput(
            queryResultState: ActionResultState.fail,
            blockErrorOrigin: BlockErrorOrigin.directFetch,
            blockErrorInfo: null,
            currentDataState: const BlockDataStateLoadedFresh(),
            syncStrategy: BlockViewportSyncStrategy.nativeQuery,
            filterCriteriaChanged: false,
            isQueryMore: trigger['queryMore']!,
            isPageShifting: trigger['pageShift']!,
            queryTypeChanged: false,
            suggestedListUpdateStrategy: ListUpdateStrategy.replace,
            hasRemoveItemIds: false,
            dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
          );

          final result = BlockQueryStateCalculator.calculate(input);

          // Baseline data remains FRESH while attaching transientErrorInfo
          expect(
            result.newBlockDataState,
            const BlockDataStateLoadedFresh(transientErrorInfo: null),
          );
          expect(result.newLoadedPhase, BlockLoadedStatePhase.fetchMoreFailed);
          expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
        }
      });

      test(
          '1.2.3 - Should evict and fallback to PENDING layout if page shift fails under explicit evictStaleContent settings',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: true,
          // Transitioning pages (e.g. NextPage or Jump to Page 10)
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
            reason: BlockPendingReasonFailed(
              errorOrigin: BlockErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });

      test(
          '1.2.4 - Standard root refresh failure preserves baseline cache under preserveStableCache rules',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          // Standard pull-to-refresh style re-query
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReasonFailed(errorInfo: null),
          ),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.refetchFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });

      test(
          '1.2.5 - Standard root refresh failure evicts cache when evictStaleContent is explicitly requested',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
            reason: BlockPendingReasonFailed(
              errorOrigin: BlockErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });
    });
  });
}
