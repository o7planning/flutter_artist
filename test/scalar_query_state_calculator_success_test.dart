import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/scalar_query_state_calculator.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '🛡️ ScalarQueryStateCalculator - Success Scenario Matrices (ActionResultState.success)',
      () {
    // =========================================================================
    // BRANCH 2.1: CRITERIA BOUNDARY MUTATED (filterCriteriaChanged == true)
    // =========================================================================
    group('Branch 2.1 - Criteria Mutated (Filter Criteria Changed)', () {
      test(
          '2.1.1 - Valid payloads on mutated filter criteria must resolve directly to LoadedFresh',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          scalarErrorOrigin: null,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateNone(),
          filterCriteriaChanged: true,
          // New filter applied successfully
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(result.newScalarDataState, const ScalarDataStateLoadedFresh());
      });
    });

    // =========================================================================
    // BRANCH 2.2: CRITERIA PRESERVED (filterCriteriaChanged == false)
    // =========================================================================
    group('Branch 2.2 - Criteria Stabilized (Filter Criteria Intact)', () {
      test(
          '2.2.1 - Successful query from stale state must clear stale flag and mount LoadedFresh',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          scalarErrorOrigin: null,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedStale(
            reason: ScalarLoadedStateStaleReason.event,
          ) as ScalarDataState,
          // Stale state before query
          filterCriteriaChanged: false,
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(result.newScalarDataState, const ScalarDataStateLoadedFresh());
      });

      test(
          '2.2.2 - Successful background polling must clear any prior transient error and retain LoadedFresh',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.success,
          scalarErrorOrigin: null,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(
            transientErrorInfo: null,
          ),
          filterCriteriaChanged: false,
          isBackgroundPolling: true,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(result.newScalarDataState, const ScalarDataStateLoadedFresh());
        expect(
          (result.newScalarDataState as ScalarDataStateLoadedFresh)
              .hasTransientError,
          false,
        );
      });
    });
  });
}
