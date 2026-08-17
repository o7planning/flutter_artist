import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/block_query_state_calculator.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '🛡️ QueryStateCalculator - Success Scenario Matrices (ActionResultState.success)',
      () {
    // =========================================================================
    // BRANCH 2.1: CONTEXT BOUNDARY MUTATED (filterCriteriaChanged == true)
    // =========================================================================
    group('Branch 2.1 - Context Mutated (Parent or Filter Criteria Changed)',
        () {
      test(
          '2.1.1 - Valid payloads on fresh contexts must overwrite the active list completely',
          () {
        final strategies = [
          BlockViewportSyncStrategy.nativeQuery,
          BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          BlockViewportSyncStrategy.effectedItemIdsQuery
        ];

        for (var strategy in strategies) {
          final input = BlockQueryCalculatorInput(
            queryResultState: ActionResultState.success,
            blockErrorOrigin: null,
            blockErrorInfo: null,
            currentDataState: const BlockDataStateNone(),
            syncStrategy: strategy,
            filterCriteriaChanged: true,
            // Context shift active
            isQueryMore: false,
            isPageShifting: false,
            queryTypeChanged: false,
            suggestedListUpdateStrategy: ListUpdateStrategy.merge,
            hasRemoveItemIds: false,
            dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
          );

          final result = BlockQueryStateCalculator.calculate(input);

          expect(result.newBlockDataState, const BlockDataStateLoadedFresh());
          expect(result.newLoadedPhase, BlockLoadedStatePhase.idle);
          expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
          expect(result.forcePruneMissingIds, false);
        }
      });
    });

    // =========================================================================
    // BRANCH 2.2: CONTEXT PRESERVED (filterCriteriaChanged == false)
    // =========================================================================
    group('Branch 2.2 - Context Stabilized (Parent or Filter Criteria Intact)',
        () {
      test(
          '2.2.1 - Should proxy directly to the fallback configuration mapping when nativeQuery stands active',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          blockErrorOrigin: null,
          blockErrorInfo: null,
          currentDataState: BlockDataStateLoadedStale(
            reason: BlockLoadedStateStaleReason.event,
          ),
          // Stale state before query
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, const BlockDataStateLoadedFresh());
        expect(result.newLoadedPhase, BlockLoadedStatePhase.idle);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });

      test(
          '2.2.2 - Full viewport overwrite constraint must be honored when executing effectedAndViewportItemIdsQuery synchronization',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          blockErrorOrigin: null,
          blockErrorInfo: null,
          currentDataState: const BlockDataStateLoadedFresh(),
          syncStrategy:
              BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, const BlockDataStateLoadedFresh());
        expect(result.newLoadedPhase, BlockLoadedStatePhase.idle);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });

      test(
          '2.2.3 - Incremental content merges should apply localized row injections without wiping other elements',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          blockErrorOrigin: null,
          blockErrorInfo: null,
          currentDataState: const BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.replace,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, const BlockDataStateLoadedFresh());
        expect(result.newLoadedPhase, BlockLoadedStatePhase.idle);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });
    });

    // =========================================================================
    // BRANCH 2.3: STRUCTURAL OVERRIDES (queryTypeChanged == true)
    // =========================================================================
    group('Branch 2.3 - Structural Override Gates', () {
      test(
          '2.3.1 - Should forcefully redirect any strategy to clear-and-replace if a structural query type shift drops',
          () {
        const input = BlockQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          blockErrorOrigin: null,
          blockErrorInfo: null,
          currentDataState: const BlockDataStateLoadedFresh(),
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          filterCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: true,
          // Layout structural type shift triggered
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = BlockQueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, const BlockDataStateLoadedFresh());
        expect(result.newLoadedPhase, BlockLoadedStatePhase.idle);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });
    });
  });
}
