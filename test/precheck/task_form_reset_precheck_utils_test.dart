import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskFormResetPrecheckUtils Tests', () {
    const freshTask = TaskDataStateLoadedFresh();
    const freshForm = FormDataStateLoadedFresh();

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: true,
        hasForm: true,
        taskDataState: freshTask,
        formDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.busy));
    });

    test('Should return noForm when hasForm is false', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: false,
        taskDataState: freshTask,
        formDataState: null,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.noForm));
    });

    test('Should return taskNotReady when task is pending', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        taskDataState: const TaskDataStatePending.initial(),
        formDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.taskNotReady));
    });

    test('Should return formDataNotLoaded when form is not loaded fresh', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        taskDataState: freshTask,
        formDataState: const FormDataStatePending(),
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.formDataNotLoaded));
    });

    test('Should return formIsNotDirty when isDirty is false', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        taskDataState: freshTask,
        formDataState: freshForm,
        isDirty: false,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.formIsNotDirty));
    });

    test(
        'Should return notAllowed when checkFormResetAllowed returns notAllowed',
        () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        taskDataState: freshTask,
        formDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormResetPrecheck.notAllowed));
    });

    test('Should return yes when all conditions pass', () {
      final result = TaskFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        taskDataState: freshTask,
        formDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
