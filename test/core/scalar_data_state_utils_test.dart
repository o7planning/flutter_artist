import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/error/_scalar_error_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScalarDataStateUtils.calculateNewLazyDataState', () {
    final mockScalarErrorInfo = ScalarErrorInfo(
      scalarErrorMethod: ScalarErrorMethod.performQuery,
      error: 'SocketException: Connection refused',
      errorStackTrace: StackTrace.empty,
    );

    test('Child scalar: transitions to None when hasParentValue is false', () {
      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: const ScalarDataStateLoadedFresh(),
        hasParentValue: false,
        isRootScalar: false,
        parentValueChanged: false,
        filterCriteriaChanged: false,
      );

      expect(nextState, isA<ScalarDataStateNone>());
    });

    test('Root scalar: remains loaded when hasParentValue is false', () {
      const rootFresh = ScalarDataStateLoadedFresh();

      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: rootFresh,
        hasParentValue: false,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: false,
      );

      expect(nextState, equals(rootFresh));
    });

    test(
        'Child scalar: evicts memory cache to Pending when parentValueChanged is true',
        () {
      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: const ScalarDataStateLoadedFresh(),
        hasParentValue: true,
        isRootScalar: false,
        parentValueChanged: true,
        filterCriteriaChanged: false,
      );

      expect(nextState, isA<ScalarDataStatePending>());
      final pending = nextState as ScalarDataStatePending;
      expect(pending.reason, isA<ScalarPendingReasonInitial>());
    });

    test(
        'Pending: preserves failure history when filterCriteriaChanged is true',
        () {
      final pendingFailed = ScalarDataStatePending.failed(
        errorOrigin: ScalarErrorOrigin.directFetch,
        errorInfo: mockScalarErrorInfo,
      );

      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: pendingFailed,
        hasParentValue: true,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: true,
      );

      expect(nextState, isA<ScalarDataStatePending>());
      final pending = nextState as ScalarDataStatePending;
      expect(pending.reason, isA<ScalarPendingReasonFilterChanged>());
      expect(pending.errorInfo, equals(mockScalarErrorInfo));
      expect(pending.underlyingFailureReason, isNotNull);
      expect(pending.hasFailure, isTrue);
    });

    test('LoadedFresh: marks metric as Stale.filterChanged upon filter update',
        () {
      const fresh = ScalarDataStateLoadedFresh();

      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: fresh,
        hasParentValue: true,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: true,
      );

      expect(nextState, isA<ScalarDataStateLoadedStale>());
      final stale = nextState as ScalarDataStateLoadedStale;
      expect(stale.reason, isA<ScalarLoadedStateStaleReasonFilterChanged>());
      expect(stale.errorInfo, isNull);
      expect(stale.hasFailure, isFalse);
    });

    test('LoadedFresh: marks metric as Stale.event upon domain broadcast', () {
      const fresh = ScalarDataStateLoadedFresh();

      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: fresh,
        hasParentValue: true,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: false,
        hasIncomingEvent: true,
      );

      expect(nextState, isA<ScalarDataStateLoadedStale>());
      final stale = nextState as ScalarDataStateLoadedStale;
      expect(stale.reason, isA<ScalarLoadedStateStaleReasonEvent>());
    });

    test(
        'LoadedStale(Failed): preserves scalar failure across filter changes and incoming events',
        () {
      final staleFailedState = ScalarDataStateLoadedStale.failed(
        errorOrigin: ScalarErrorOrigin.directFetch,
        errorInfo: mockScalarErrorInfo,
      );

      // 1. Invalidate via filter modification
      final stateAfterFilter = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: staleFailedState,
        hasParentValue: true,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: true,
      );

      expect(stateAfterFilter, isA<ScalarDataStateLoadedStale>());
      final staleFilter = stateAfterFilter as ScalarDataStateLoadedStale;
      expect(
          staleFilter.reason, isA<ScalarLoadedStateStaleReasonFilterChanged>());
      expect(staleFilter.errorInfo, equals(mockScalarErrorInfo));
      expect(staleFilter.hasFailure, isTrue);

      // 2. Invalidate via subsequent domain event
      final stateAfterEvent = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: stateAfterFilter,
        hasParentValue: true,
        isRootScalar: true,
        parentValueChanged: false,
        filterCriteriaChanged: false,
        hasIncomingEvent: true,
      );

      expect(stateAfterEvent, isA<ScalarDataStateLoadedStale>());
      final staleEvent = stateAfterEvent as ScalarDataStateLoadedStale;
      expect(staleEvent.reason, isA<ScalarLoadedStateStaleReasonEvent>());
      expect(staleEvent.errorInfo, equals(mockScalarErrorInfo));
      expect(staleEvent.underlyingFailureReason?.errorOrigin,
          equals(ScalarErrorOrigin.directFetch));
    });
  });
}
