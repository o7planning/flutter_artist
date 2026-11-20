import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockFormEnablePrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: true,
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormEnablePrecheck.busy));
    });

    test('Should return noForm when formModel is null', () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: false, // Form model is missing
        isStateReadyForForm: true,
        formDataState: null,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormEnablePrecheck.noForm));
    });

    test('Should return hostStateNotReadyForForm when state is not ready', () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        isStateReadyForForm: false, // State not ready
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockFormEnablePrecheck.hostStateNotReadyForForm),
      );
    });

    test(
        'Should return notAllowed when business rule checkEditItemOnFormAllowed returns notAllowed',
        () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) =>
            CheckAllowResult.notAllowed(), // Disallowed
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormEnablePrecheck.notAllowed));
    });

    test(
        'Should return checkAllowMethodError when checkEditItemOnFormAllowed returns error',
        () {
      final mockErrorInfo = ErrorInfo.fromError(
        error: Exception('Permission check failed'),
        stackTrace: StackTrace.current,
      );

      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockFormEnablePrecheck.checkAllowMethodError),
      );
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkEditItemOnFormAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
