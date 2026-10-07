import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

// Mock đơn giản cho FormState trong test
class MockFormBuilderState {
  final bool isValidResult;

  MockFormBuilderState(this.isValidResult);

  bool validate({bool focusOnInvalid = true}) => isValidResult;
}

void main() {
  group('TaskSubmitPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = TaskSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: true,
        checkAllow: true,
        checkValidate: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        hasForm: false,
        formDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskSubmitPrecheck.busy));
    });

    test('Should return taskInPendingState when task dataState is pending', () {
      final result = TaskSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkValidate: true,
        taskDataState: const TaskDataStatePending.initial(),
        hasForm: false,
        formDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskSubmitPrecheck.taskInPendingState));
    });

    test(
        'Should return taskAlreadySubmitted when task is already successfully submitted',
        () {
      final result = TaskSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkValidate: true,
        taskDataState: const TaskDataStateSubmissionAttemptedSuccess(),
        hasForm: false,
        formDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskSubmitPrecheck.taskAlreadySubmitted));
    });

    test('Should return formInvalidated when active form validation fails', () {
      final mockFormState =
          MockFormBuilderState(false); // Validate trả về false (không hợp lệ)

      final result = TaskSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkValidate: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        hasForm: true,
        formDataState: const FormDataStateLoadedFresh(),
        getActiveFormStates: () => [mockFormState],
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskSubmitPrecheck.formInvalidated));
    });

    test(
        'Should return yes when all task and form conditions pass successfully',
        () {
      final mockFormState = MockFormBuilderState(true); // Validate hợp lệ

      final result = TaskSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkValidate: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        hasForm: true,
        formDataState: const FormDataStateLoadedFresh(),
        getActiveFormStates: () => [mockFormState],
      );

      expect(result.yes, isTrue);
    });
  });
}
