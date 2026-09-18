import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormDataStateUtils.calculateNewLazyDataState', () {
    final mockErrorInfo = ErrorInfo(
      errorMessage: 'Network timeout',
      errorDetails: ['Failed to fetch form detail'],
      stackTrace: null,
    );
    final failedReason = FormLoadedStateStaleReasonFailed(
      errorInfo: mockErrorInfo,
    );

    test('Transitions to None when hasCurrentItem is false', () {
      final nextState = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        hasCurrentItem: false,
        currentItemChanged: false,
      );

      expect(nextState, isA<FormDataStateNone>());
    });

    test('Transitions to Pending when state is None or Pending and item exists',
        () {
      final fromNone = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateNone(),
        hasCurrentItem: true,
        currentItemChanged: false,
      );
      final fromPending = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStatePending(),
        hasCurrentItem: true,
        currentItemChanged: false,
      );

      expect(fromNone, isA<FormDataStatePending>());
      expect(fromPending, isA<FormDataStatePending>());
    });

    test(
        'FatalError: resets to Pending if item changed, retains state if item unchanged',
        () {
      final fatalState = FormDataStateFatalError(errorInfo: mockErrorInfo);

      final stateWhenItemChanged = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: fatalState,
        hasCurrentItem: true,
        currentItemChanged: true,
      );
      final stateWhenItemSame = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: fatalState,
        hasCurrentItem: true,
        currentItemChanged: false,
      );

      expect(stateWhenItemChanged, isA<FormDataStatePending>());
      expect(stateWhenItemSame, equals(fatalState));
    });

    test('LoadedFresh: transitions to Pending when item changed', () {
      const freshState = FormDataStateLoadedFresh();

      final nextState = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: freshState,
        hasCurrentItem: true,
        currentItemChanged: true,
      );

      expect(nextState, isA<FormDataStatePending>());
    });

    test(
        'LoadedFresh: transitions to Stale(itemRefreshed) without prior failure when item refreshed in-place',
        () {
      const freshState = FormDataStateLoadedFresh();

      final nextState = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: freshState,
        hasCurrentItem: true,
        currentItemChanged: false,
      );

      expect(nextState, isA<FormDataStateLoadedStale>());
      final stale = nextState as FormDataStateLoadedStale;
      expect(stale.reason, isA<FormLoadedStateStaleReasonItemRefreshed>());
      expect(stale.errorInfo, isNull);
      expect(stale.hasFailure, isFalse);
    });

    test(
        'LoadedStale(Failed): preserves error as retainedFailureReason when item refreshed in-place',
        () {
      final staleFailedState = FormDataStateLoadedStale.failed(
        errorInfo: mockErrorInfo,
      );

      final nextState = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: staleFailedState,
        hasCurrentItem: true,
        currentItemChanged: false,
      );

      expect(nextState, isA<FormDataStateLoadedStale>());
      final stale = nextState as FormDataStateLoadedStale;
      expect(stale.reason, isA<FormLoadedStateStaleReasonItemRefreshed>());

      final refreshedReason =
          stale.reason as FormLoadedStateStaleReasonItemRefreshed;
      expect(refreshedReason.retainedFailureReason, isNotNull);
      expect(refreshedReason.retainedFailureReason!.errorInfo,
          equals(mockErrorInfo));
      expect(stale.errorInfo, equals(mockErrorInfo));
      expect(stale.underlyingFailureReason, isNotNull);
      expect(stale.hasFailure, isTrue);
    });

    test(
        'LoadedStale(Event with retainedFailure): chains failure over subsequent item refreshes',
        () {
      final chainedStaleState = FormDataStateLoadedStale(
        reason: FormLoadedStateStaleReasonEvent(
          retainedFailureReason: failedReason,
        ),
      );

      final nextState = FormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: chainedStaleState,
        hasCurrentItem: true,
        currentItemChanged: false,
      );

      expect(nextState, isA<FormDataStateLoadedStale>());
      final stale = nextState as FormDataStateLoadedStale;
      expect(stale.reason, isA<FormLoadedStateStaleReasonItemRefreshed>());
      expect(stale.errorInfo, equals(mockErrorInfo));
    });
  });
}
