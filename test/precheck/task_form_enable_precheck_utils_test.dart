import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('TaskFormEnablePrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();
    const freshTaskDataState = TaskDataStateLoadedFresh();
    const pendingTaskDataState = TaskDataStatePending.initial();
    const staleTaskDataState = TaskDataStateLoadedStale();
    const successTaskDataState = TaskDataStateCompleted();

    test('Should return noForm when formModel is null', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: false, // Form model is missing
        taskDataState: freshTaskDataState,
        formDataState: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormEnablePrecheck.noForm));
    });

    test('Should return taskInPendingState when task state is pending', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        taskDataState: pendingTaskDataState, // State is pending
        formDataState: defaultFormDataState,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormEnablePrecheck.taskInPendingState));
    });

    test('Should return taskInStaleState when task state is stale', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        taskDataState: staleTaskDataState, // State is stale
        formDataState: defaultFormDataState,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormEnablePrecheck.taskInStaleState));
    });

    test('Should return taskAlreadySubmitted when task submission succeeded',
        () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        taskDataState: successTaskDataState, // Submission attempted success
        formDataState: defaultFormDataState,
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(TaskFormEnablePrecheck.taskAlreadySubmitted));
    });

    test('Should return formInNoneState when form dataState is none', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        taskDataState: freshTaskDataState,
        formDataState: const FormDataStateNone(), // Form in none state
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormEnablePrecheck.formInNoneState));
    });

    test(
        'Should return yes when all task form enable conditions pass successfully',
        () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        taskDataState: freshTaskDataState,
        formDataState: defaultFormDataState, // Loaded fresh
      );

      expect(result.yes, isTrue);
    });
  });
}
