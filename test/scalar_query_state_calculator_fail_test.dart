import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/_core_/_utils_/scalar_query_state_calculator.dart';
import 'package:flutter_artist/src/core/enums/fallback_dilemma_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      '🛡️ ScalarQueryStateCalculator - Failure Scenario Matrices (ActionResultState.fail)',
      () {
    // =========================================================================
    // BRANCH 1.1: CRITERIA BOUNDARY MUTATED (filterCriteriaChanged == true)
    // =========================================================================
    group('Branch 1.1 - Criteria Mutated (Filter Criteria Changed)', () {
      test(
          '1.1.1 - Should preserve cache as STALE when filter changes during failure under preserveStableCache',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(),
          filterCriteriaChanged: true,
          // Criteria mutation active
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        // Retains previous scalar value on screen, but flags as STALE due to criteria mismatch
        expect(
          result.newScalarDataState,
          ScalarDataStateLoadedStale(
            reason: ScalarLoadedStateStaleReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });

      test(
          '1.1.2 - Should evict and fallback to PENDING when filter changes during failure under evictStaleContent',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(),
          filterCriteriaChanged: true,
          // Criteria mutation active
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(
          result.newScalarDataState,
          const ScalarDataStatePending(
            reason: ScalarPendingReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });

      test(
          '1.1.3 - Cold baseline with mutated filter criteria MUST always fallback to PENDING on failure',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateNone(),
          // Cold uninitialized state
          filterCriteriaChanged: true,
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(
          result.newScalarDataState,
          const ScalarDataStatePending(
            reason: ScalarPendingReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });
    });

    // =========================================================================
    // BRANCH 1.2: CRITERIA PRESERVED (filterCriteriaChanged == false)
    // =========================================================================
    group('Branch 1.2 - Criteria Stabilized (Filter Criteria Intact)', () {
      test(
          '1.2.1 - Should retain FRESH state and attach transientErrorInfo when background polling fails',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(),
          filterCriteriaChanged: false,
          isBackgroundPolling: true,
          // Non-blocking background tick
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        // Baseline metric remains FRESH while attaching transientErrorInfo
        expect(
          result.newScalarDataState,
          const ScalarDataStateLoadedFresh(transientErrorInfo: null),
        );
      });

      test(
          '1.2.2 - Explicit root refresh failure preserves baseline cache under preserveStableCache rules',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(),
          filterCriteriaChanged: false,
          isBackgroundPolling: false,
          // Standard manual refresh
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(
          result.newScalarDataState,
          ScalarDataStateLoadedStale(
            reason: ScalarLoadedStateStaleReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });

      test(
          '1.2.3 - Explicit root refresh failure evicts cache when evictStaleContent is explicitly requested',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStateLoadedFresh(),
          filterCriteriaChanged: false,
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.evictStaleContent,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(
          result.newScalarDataState,
          const ScalarDataStatePending(
            reason: ScalarPendingReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });

      test(
          '1.2.4 - Cold baseline without prior data remains in PENDING upon query failure',
          () {
        const input = ScalarQueryCalculatorInput(
          queryResultState: ActionResultState.fail,
          scalarErrorOrigin: ScalarErrorOrigin.directFetch,
          scalarErrorInfo: null,
          currentDataState: ScalarDataStatePending.initial(),
          filterCriteriaChanged: false,
          isBackgroundPolling: false,
          dilemmaStrategy: FallbackDilemmaStrategy.preserveStableCache,
        );

        final result = ScalarQueryStateCalculator.calculate(input);

        expect(
          result.newScalarDataState,
          const ScalarDataStatePending(
            reason: ScalarPendingReasonFailed(
              errorOrigin: ScalarErrorOrigin.directFetch,
              errorInfo: null,
            ),
          ),
        );
      });
    });
  });
}
