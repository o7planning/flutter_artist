import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

// Mock đơn giản cho FormBuilderState trong test
class MockFormBuilderState {
  final bool isValidResult;

  MockFormBuilderState(this.isValidResult);

  bool validate({bool focusOnInvalid = true}) => isValidResult;
}

void main() {
  group('BlockFormSavePrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockFormSavePrecheckUtils.checkBeforeSaveForm(
        checkBusy: true,
        isBusy: true,
        // System is busy
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkValidate: true,
        getActiveFormStates: () => [],
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormSavePrecheck.busy));
    });

    test('Should return noForm when block has no form model', () {
      final result = BlockFormSavePrecheckUtils.checkBeforeSaveForm(
        checkBusy: true,
        isBusy: false,
        hasForm: false,
        // No form model
        formDataState: null,
        isDirty: true,
        checkValidate: true,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormSavePrecheck.noForm));
    });

    test('Should return formIsNotDirty when form has no unsaved changes', () {
      final result = BlockFormSavePrecheckUtils.checkBeforeSaveForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: false,
        // Form is clean / not dirty
        checkValidate: true,
        getActiveFormStates: () => [],
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormSavePrecheck.formIsNotDirty));
    });

    test('Should return formInvalidated when active form validation fails', () {
      final mockInvalidForm =
          MockFormBuilderState(false); // Validate trả về false

      final result = BlockFormSavePrecheckUtils.checkBeforeSaveForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkValidate: true,
        getActiveFormStates: () => [mockInvalidForm],
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormSavePrecheck.formInvalidated));
    });

    test(
        'Should return yes when all form save precheck conditions pass successfully',
        () {
      final mockValidForm = MockFormBuilderState(true); // Validate hợp lệ

      final result = BlockFormSavePrecheckUtils.checkBeforeSaveForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkValidate: true,
        getActiveFormStates: () => [mockValidForm],
      );

      expect(result.yes, isTrue);
    });
  });
}
