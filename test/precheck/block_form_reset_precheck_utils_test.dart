import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockFormResetPrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: true,
        // System is busy
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormResetPrecheck.busy));
    });

    test('Should return noForm when block has no form model', () {
      final result = BlockFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: false,
        // No form model
        formDataState: null,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormResetPrecheck.noForm));
    });

    test('Should return formIsNotDirty when form has no changes', () {
      final result = BlockFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: false,
        // Form is clean / not dirty
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormResetPrecheck.formIsNotDirty));
    });

    test(
        'Should return notAllow when business rule checkFormResetAllowed returns notAllow',
        () {
      final result = BlockFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () =>
            CheckAllowResult.notAllow(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormResetPrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result = BlockFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        formDataState: defaultFormDataState,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
