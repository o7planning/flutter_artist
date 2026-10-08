import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/error/_task_error_info.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/error/_task_error_info.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskFormDataStateUtils Tests', () {
    final mockErrorInfo = ErrorInfo(
      errorMessage: 'Network timeout',
      errorDetails: ['Failed to fetch task init data'],
      stackTrace: null,
    );

    final mockTaskErrorInfo = TaskErrorInfo(
      taskErrorMethod: TaskErrorMethod.performLoadInitData,
      error: "Error",
      errorStackTrace: StackTrace.empty,
    );

    test('Should return FormDataStateNone when hasInitData is false', () {
      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: const TaskDataStateLoadedFresh(),
        hasInitData: false,
      );

      expect(result, isA<FormDataStateNone>());
    });

    test('Should return FormDataStatePending when taskDataState is Pending',
        () {
      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: const TaskDataStatePending.initial(),
        hasInitData: true,
      );

      expect(result, isA<FormDataStatePending>());
    });

    test(
        'Should transition to Pending.hostDataRefreshed and preserve retainedFailureReason when task is pending with prior failure',
        () {
      final currentStaleState = FormDataStateLoadedStale.failed(
        errorInfo: mockErrorInfo,
      );

      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: currentStaleState,
        taskDataState: const TaskDataStatePending.initial(),
        hasInitData: true,
      );

      expect(result, isA<FormDataStatePending>());
      final pendingState = result as FormDataStatePending;
      expect(pendingState.reason, isA<FormPendingReasonHostDataRefreshed>());
      expect(pendingState.hasFailure, isTrue);
      expect(pendingState.errorInfo, equals(mockErrorInfo));
    });

    test(
        'Should return Pending when taskDataState is LoadedFresh and currentFormDataState is None',
        () {
      // Case: Form is initially none, task becomes fresh -> form becomes pending
      // so it can execute its own independent data loading lifecycle.
      final resultFromNone = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateNone(),
        taskDataState: const TaskDataStateLoadedFresh(),
        hasInitData: true,
      );
      expect(resultFromNone, isA<FormDataStatePending>());
    });

    test(
        'Should transition to LoadedStale.hostDataRefreshed when taskDataState is LoadedFresh and currentFormDataState is not None',
        () {
      // Case: Form is already stale/fresh, task reloads fresh -> form becomes stale
      // so it can execute its own independent data loading lifecycle.
      final resultFromStale = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedStale(
          reason: FormLoadedStateStaleReasonEvent(),
        ),
        taskDataState: const TaskDataStateLoadedFresh(),
        hasInitData: true,
      );
      expect(resultFromStale, isA<FormDataStateLoadedStale>());
      expect((resultFromStale as FormDataStateLoadedStale).reason,
          isA<FormLoadedStateStaleReasonHostDataRefreshed>());

      final resultFromFresh = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: const TaskDataStateLoadedFresh(),
        hasInitData: true,
      );
      expect(resultFromFresh, isA<FormDataStateLoadedStale>());
      expect((resultFromFresh as FormDataStateLoadedStale).reason,
          isA<FormLoadedStateStaleReasonHostDataRefreshed>());
    });

    test(
        'Should transition to LoadedStale(Failed) when taskDataState is LoadedStale with error info',
        () {
      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: TaskDataStateLoadedStale(
          staleErrorInfo: mockTaskErrorInfo,
        ),
        hasInitData: true,
      );

      expect(result, isA<FormDataStateLoadedStale>());
      final staleState = result as FormDataStateLoadedStale;
      expect(staleState.reason, isA<FormLoadedStateStaleReasonFailed>());
    });

    test(
        'Should transition to LoadedStale.hostDataRefreshed when taskDataState is LoadedStale without error info',
        () {
      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: const TaskDataStateLoadedStale(
          staleErrorInfo: null,
        ),
        hasInitData: true,
      );

      expect(result, isA<FormDataStateLoadedStale>());
      final staleState = result as FormDataStateLoadedStale;
      expect(staleState.reason,
          isA<FormLoadedStateStaleReasonHostDataRefreshed>());
    });

    test('Should transition to LoadedStale when task submission failed', () {
      final result = TaskFormDataStateUtils.calculateNewLazyDataState(
        currentFormDataState: const FormDataStateLoadedFresh(),
        taskDataState: TaskDataStateSubmissionAttemptedFailed(
          submissionErrorInfo: mockTaskErrorInfo,
        ),
        hasInitData: true,
      );

      expect(result, isA<FormDataStateLoadedStale>());
      final staleState = result as FormDataStateLoadedStale;
      expect(staleState.reason, isA<FormLoadedStateStaleReasonFailed>());
    });
  });
}
