import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/block_loaded_state_phase.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/query_state_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/block_loaded_state_phase.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/query_state_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '🛡️ QueryStateCalculator - Failure Scenario Matrices (ActionResultState.fail)',
      () {
    // =========================================================================
    // BRANCH 1.1: CONTEXT BOUNDARY MUTATED (parentOrCriteriaChanged == true)
    // =========================================================================
    group('Branch 1.1 - Context Mutated (Parent or Filter Criteria Changed)',
        () {
      test(
          '1.1.1 - Should fallback to PENDING and replace list if context changes during failure',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy:
              BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          parentOrCriteriaChanged: true,
          // Context mutation active
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
              reason: PendingReasonFetchFailed(errorInfo: null)),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
        expect(result.forcePruneMissingIds, false);
      });

      test(
          '1.1.2 - Context mutation must override and block infinite scroll lazy load bounds',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          parentOrCriteriaChanged: true,
          // Context mutated takes supreme priority
          isQueryMore: true,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
              reason: PendingReasonFetchFailed(errorInfo: null)),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });
    });

    // =========================================================================
    // BRANCH 1.2: CONTEXT PRESERVED (parentOrCriteriaChanged == false)
    // =========================================================================
    group('Branch 1.2 - Context Stabilized (Parent or Filter Criteria Intact)',
        () {
      test(
          '1.2.1 - EAGER LOCAL PRUNING GATE: Should drop deleted item IDs immediately even if re-query fails',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: true,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.replace,
          hasRemoveItemIds: true,
          // Destructive operation footprint active
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        // UX Check: Keeps valid rows on screen, preserves LOADED STALE, but flags for mutation failure & local prune
        expect(
          result.newBlockDataState,
          const BlockDataStateLoadedStale(
              reason: LoadedStateStaleReason.fetchFailed),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.mutationFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
        expect(result.forcePruneMissingIds, true); // Active local cache janitor
      });

      test(
          '1.2.2 - Should maintain readiness when page shifting or lazy loading under preserveStableCache rules',
          () {
        final flowTriggers = [
          {'queryMore': true, 'pageShift': false},
          {'queryMore': false, 'pageShift': true}
        ];

        for (var trigger in flowTriggers) {
          final input = QueryCalculatorInput(
            queryResultState: ActionResultState.fail,
            blockErrorInfo: null,
            currentDataState: const BlockDataStateLoadedFresh(),
            syncStrategy: BlockViewportSyncStrategy.nativeQuery,
            parentOrCriteriaChanged: false,
            isQueryMore: trigger['queryMore']!,
            isPageShifting: trigger['pageShift']!,
            queryTypeChanged: false,
            suggestedListUpdateStrategy: ListUpdateStrategy.replace,
            hasRemoveItemIds: false,
            dilemmaStrategy: FallbackDilemmaStrategy
                .preserveStableCache, // Default protective policy
          );

          final result = QueryStateCalculator.calculate(input);

          expect(
            result.newBlockDataState,
            const BlockDataStateLoadedStale(
                reason: LoadedStateStaleReason.fetchFailed),
          );
          expect(result.newLoadedPhase, BlockLoadedStatePhase.fetchMoreFailed);
          expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
        }
      });

      test(
          '1.2.3 - Should evict and fallback to PENDING layout if page shift fails under explicit evictStaleContent settings',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: true,
          // Transitioning pages (e.g. NextPage or Jump to Page 10)
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
              reason: PendingReasonFetchFailed(errorInfo: null)),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });

      test(
          '1.2.4 - Standard root refresh failure preserves baseline cache under preserveStableCache rules',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          // Standard pull-to-refresh style re-query
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStateLoadedStale(
              reason: LoadedStateStaleReason.fetchFailed),
        );
        expect(result.newLoadedPhase, BlockLoadedStatePhase.refetchFailed);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });

      test(
          '1.2.5 - Standard root refresh failure evicts cache when evictStaleContent is explicitly requested',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(
          result.newBlockDataState,
          const BlockDataStatePending(
              reason: PendingReasonFetchFailed(errorInfo: null)),
        );
        expect(result.newLoadedPhase, isNull);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });
    });
  });
}
