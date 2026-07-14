import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/_fallback_dilemma_strategy.dart';
import 'package:flutter_artist/src/core/utils/query_state_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '️ QueryStateCalculator - Success Scenario Matrices (ActionResultState.success)',
      () {
    // =========================================================================
    // BRANCH 2.1: CONTEXT BOUNDARY MUTATED (parentOrCriteriaChanged == true)
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
          final input = QueryCalculatorInput(
            queryResultState: ActionResultState.success,
            currentDataState: DataState.none,
            syncStrategy: strategy,
            parentOrCriteriaChanged: true,
            // Context shift active
            isQueryMore: false,
            isPageShifting: false,
            queryTypeChanged: false,
            suggestedListUpdateStrategy: ListUpdateStrategy.merge,
            hasRemoveItemIds: false,
            dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
          );

          final result = QueryStateCalculator.calculate(input);

          expect(result.newBlockDataState, DataState.ready);
          expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
        }
      });
    });

    // =========================================================================
    // BRANCH 2.2: CONTEXT PRESERVED (parentOrCriteriaChanged == false)
    // =========================================================================
    group('Branch 2.2 - Context Stabilized (Parent or Filter Criteria Intact)',
        () {
      test(
          '2.2.1 - Should proxy directly to the fallback configuration mapping when nativeQuery stands active',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.success,
          currentDataState: DataState.ready,
          syncStrategy: BlockViewportSyncStrategy.nativeQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          // Expected proxy feedback strategy
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, DataState.ready);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.merge);
      });

      test(
          '2.2.2 - Full viewport overwrite constraint must be honored when executing effectedAndViewportItemIdsQuery synchronization',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.success,
          currentDataState: DataState.ready,
          syncStrategy: BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, DataState.ready);
        expect(result.realListUpdateStrategy, ListUpdateStrategy.replace);
      });

      test(
          '2.2.3 - Incremental content merges should apply localized row injections without wiping other elements',
          () {
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.success,
          currentDataState: DataState.ready,
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: false,
          suggestedListUpdateStrategy: ListUpdateStrategy.replace,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, DataState.ready);
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
        const input = QueryCalculatorInput(
          queryResultState: ActionResultState.success,
          currentDataState: DataState.ready,
          syncStrategy: BlockViewportSyncStrategy.effectedItemIdsQuery,
          // Normally commands an inline merge
          parentOrCriteriaChanged: false,
          isQueryMore: false,
          isPageShifting: false,
          queryTypeChanged: true,
          //  Layout structural type shift triggered
          suggestedListUpdateStrategy: ListUpdateStrategy.merge,
          hasRemoveItemIds: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = QueryStateCalculator.calculate(input);

        expect(result.newBlockDataState, DataState.ready);
        expect(result.realListUpdateStrategy,
            ListUpdateStrategy.replace); // Overridden successfully
      });
    });
  });
}
