import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('FormModelPatchFormFieldsPrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
        checkBusy: true,
        isBusy: true, // System is busy
        formDataState: defaultFormDataState,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(FormModelPatchFormFieldsPrecheck.busy));
    });

    test('Should return formInNoneState error when form is in none state', () {
      final result =
          FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
        checkBusy: true,
        isBusy: false,
        formDataState: const FormDataStateNone(), // Form in none state
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(FormModelPatchFormFieldsPrecheck.formInNoneState));
    });

    test('Should return formInPendingState error when form is in pending state',
        () {
      final result =
          FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
        checkBusy: true,
        isBusy: false,
        formDataState:
            const FormDataStatePending.initial(), // Form in pending state
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(FormModelPatchFormFieldsPrecheck.formInPendingState));
    });

    test(
        'Should return formInFatalErrorState error when form is in fatal error state',
        () {
      final result =
          FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
        checkBusy: true,
        isBusy: false,
        formDataState: FormDataStateFatalError(
          errorInfo: ErrorInfo(
              errorMessage: 'Fatal error', errorDetails: [], stackTrace: null),
        ), // Form in fatal error state
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(FormModelPatchFormFieldsPrecheck.formInFatalErrorState));
    });

    test('Should return yes when form is loaded fresh and system is not busy',
        () {
      final result =
          FormModelPatchFormFieldsPrecheckUtils.checkBeforePatchFormFields(
        checkBusy: true,
        isBusy: false,
        formDataState: defaultFormDataState, // Loaded fresh
      );

      expect(result.yes, isTrue);
    });
  });
}
