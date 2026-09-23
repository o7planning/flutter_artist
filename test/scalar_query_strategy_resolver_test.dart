import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/enums/query_hint.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScalarQueryStrategyResolver.resolveQueryPlanInternal Unit Tests', () {
    // -------------------------------------------------------------------------
    // TEST 1: Uninitialized State (ScalarDataStateNone)
    // -------------------------------------------------------------------------
    test(
        '1. Should resolve to NULL action plan when dataState is ScalarDataStateNone',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStateNone(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.force,
        provideScalarContext: true,
      );

      expect(plan.action, isNull);
    });

    // -------------------------------------------------------------------------
    // TEST 2: Cold Pending with Visible UI Context
    // -------------------------------------------------------------------------
    test('2. Cold PENDING with visible UI context MUST resolve to performQuery',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStatePending(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.none,
        provideScalarContext:
            true, // Visible UI escalates pending state to query
      );

      expect(plan.action, equals(ScalarResolvedQueryAction.performQuery));
    });

    // -------------------------------------------------------------------------
    // TEST 3: Warm Loaded Stale with Visible UI Context
    // -------------------------------------------------------------------------
    test(
        '3. Warm LOADED STALE with visible UI context MUST resolve to performQuery',
        () {
      final mockSession = TestScalarSyncSession<String>(
        receivedEventInfos: [
          ScalarReceivedEventInfo<String>(
            eventSourceType: EventSourceType.external,
            dataTypes: const [],
          ),
        ],
      );

      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStateLoadedStale(
          reason: ScalarLoadedStateStaleReasonEvent(),
        ),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: mockSession,
        queryHint: QueryHint.none,
        provideScalarContext: true, // Visible UI escalates stale state to query
      );

      expect(plan.action, equals(ScalarResolvedQueryAction.performQuery));
    });

    // -------------------------------------------------------------------------
    // TEST 4: Explicit Force Hint (QueryHint.force) on Fresh Data
    // -------------------------------------------------------------------------
    test(
        '4. Explicit QueryHint.force on LOADED FRESH data MUST force performQuery',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStateLoadedFresh(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.force, // Explicit user/pipeline force
        provideScalarContext: true,
      );

      expect(plan.action, equals(ScalarResolvedQueryAction.performQuery));
    });

    // -------------------------------------------------------------------------
    // TEST 5: Clean LOADED FRESH Data without Force Hint
    // -------------------------------------------------------------------------
    test(
        '5. Clean LOADED FRESH scalar without force hint MUST resolve to NULL action plan',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStateLoadedFresh(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.none,
        provideScalarContext: true,
      );

      expect(plan.action, isNull);
    });

    // -------------------------------------------------------------------------
    // TEST 6: Hidden UI Context (provideScalarContext == false) without Force
    // -------------------------------------------------------------------------
    test(
        '6. Hidden UI context and QueryHint.none MUST resolve to NULL even when dataState is PENDING',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStatePending(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.none,
        provideScalarContext:
            false, // Off-screen / hidden UI -> No network call
      );

      expect(plan.action, isNull);
    });

    // -------------------------------------------------------------------------
    // TEST 7: Hidden UI Context (provideScalarContext == false) with STALE data
    // -------------------------------------------------------------------------
    test(
        '7. Hidden UI context and QueryHint.none MUST resolve to NULL even when dataState is STALE with active session',
        () {
      final mockSession = TestScalarSyncSession<String>(
        receivedEventInfos: [
          ScalarReceivedEventInfo<String>(
            eventSourceType: EventSourceType.internal,
            dataTypes: const [],
          ),
        ],
      );

      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStateLoadedStale(
          reason: ScalarLoadedStateStaleReasonEvent(),
        ),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: mockSession,
        queryHint: QueryHint.none,
        provideScalarContext: false, // Deferred query until screen mounts
      );

      expect(plan.action, isNull);
    });

    // -------------------------------------------------------------------------
    // TEST 8: Hidden UI Context OVERRIDDEN by Explicit QueryHint.force
    // -------------------------------------------------------------------------
    test(
        '8. Explicit QueryHint.force MUST override hidden UI context and trigger performQuery',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStatePending(),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.force, // Pipeline mandates force fetch
        provideScalarContext: false,
      );

      expect(plan.action, equals(ScalarResolvedQueryAction.performQuery));
    });

    // -------------------------------------------------------------------------
    // TEST 9: PENDING State with Retained Failure History
    // -------------------------------------------------------------------------
    test(
        '9. PENDING state after a failed query attempt still resolves to performQuery when visible',
        () {
      final plan =
          BlockQueryStrategyResolverTestHelper.resolveScalarPlan<String>(
        dataState: const ScalarDataStatePending(
          reason: ScalarPendingReasonFailed(
            errorOrigin: ScalarErrorOrigin.directFetch,
            errorInfo: null,
          ),
        ),
        config: ScalarEffectiveConfig.fromConfig(
          ScalarConfig(),
        ),
        syncSessionState: null,
        queryHint: QueryHint.none,
        provideScalarContext: true,
      );

      expect(plan.action, equals(ScalarResolvedQueryAction.performQuery));
    });
  });
}

// =============================================================================
// HELPER & LIGHTWEIGHT TEST STUB
// =============================================================================

/// Helper wrapper delegating to [ScalarQueryStrategyResolver.resolveQueryPlanInternal].
class BlockQueryStrategyResolverTestHelper {
  static ScalarQueryPlan<ID> resolveScalarPlan<ID extends Comparable>({
    required ScalarDataState dataState,
    required ScalarEffectiveConfig config,
    required DebugScalarSyncSessionState<ID>? syncSessionState,
    required QueryHint queryHint,
    required bool provideScalarContext,
  }) {
    return ScalarQueryStrategyResolver.resolveQueryPlanInternal<ID>(
      dataState: dataState,
      config: config,
      syncSessionState: syncSessionState,
      queryHint: queryHint,
      provideScalarContext: provideScalarContext,
    );
  }
}

/// A lightweight, standalone implementation of [DebugScalarSyncSessionState] for pure unit tests.
class TestScalarSyncSession<ID extends Comparable>
    implements DebugScalarSyncSessionState<ID> {
  @override
  final Comparable? parentScalarValueId;

  @override
  final FilterCriteria? filterCriteria;

  @override
  final List<ScalarReceivedEventInfo<ID>> receivedEventInfos;

  TestScalarSyncSession({
    this.parentScalarValueId,
    this.filterCriteria,
    this.receivedEventInfos = const [],
  });

  @override
  Scalar<Comparable, Identifiable<Comparable>, FilterInput, FilterCriteria>
      get scalar => throw UnimplementedError();
}
