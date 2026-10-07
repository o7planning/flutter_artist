import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('TaskFormEnablePrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return noForm when formModel is null', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: false, // Form model is missing
        isStateReadyForForm: true,
        formDataState: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(TaskFormEnablePrecheck.noForm));
    });

    test('Should return hostStateNotReadyForForm when task state is not ready',
        () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        isStateReadyForForm: false, // State not ready
        formDataState: defaultFormDataState,
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(TaskFormEnablePrecheck.hostStateNotReadyForForm));
    });

    test('Should return formInNoneState when form dataState is none', () {
      final result = TaskFormEnablePrecheckUtils.checkFormEnable(
        hasForm: true,
        isStateReadyForForm: true,
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
        isStateReadyForForm: true,
        formDataState: defaultFormDataState, // Loaded fresh
      );

      expect(result.yes, isTrue);
    });
  });
}
