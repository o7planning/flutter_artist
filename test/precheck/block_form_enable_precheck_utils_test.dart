import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockFormEnablePrecheckUtils Tests', () {
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return noForm when formModel is null', () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        hasForm: false,
        // Form model is missing
        isStateReadyForForm: true,
        formDataState: null,
        currentItem: 'Item A',
        checkAllow: true,
        checkItemUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormEnablePrecheck.noForm));
    });

    test('Should return hostStateNotReadyForForm when state is not ready', () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        hasForm: true,
        isStateReadyForForm: false,
        // State not ready
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkItemUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockFormEnablePrecheck.hostStateNotReadyForForm));
    });

    test(
        'Should return notAllow when business rule checkItemUpdateAllowed returns notAllow',
        () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkItemUpdateAllowed: (item) =>
            CheckAllowResult.notAllow(), // Disallowed
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockFormEnablePrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result = BlockFormEnablePrecheckUtils.checkFormEnable<String>(
        hasForm: true,
        isStateReadyForForm: true,
        formDataState: defaultFormDataState,
        currentItem: 'Item A',
        checkAllow: true,
        checkItemUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
