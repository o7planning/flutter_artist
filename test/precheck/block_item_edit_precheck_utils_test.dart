import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockItemEditPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();
    const defaultFormDataState = FormDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: true,
        // System is busy
        hasForm: true,
        blockDataState: defaultBlockDataState,
        formDataState: defaultFormDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.busy));
    });

    test('Should return noForm error when block has no form model', () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: false,
        // No form model configured
        blockDataState: defaultBlockDataState,
        formDataState: null,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.noForm));
    });

    test(
        'Should return formInFatalErrorState error when form model is in fatal error',
        () {
      final fatalErrorFormDataState = FormDataStateFatalError(
        errorInfo: ErrorInfo(
            errorMessage: 'Fatal form error',
            errorDetails: [],
            stackTrace: null),
      );

      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        formDataState: fatalErrorFormDataState,
        // Form in fatal error state
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(BlockItemEditPrecheck.formInFatalErrorState));
    });

    test('Should return noTarget error when target item is null', () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        formDataState: defaultFormDataState,
        item: null,
        // No target item provided
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.noTarget));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: const BlockDataStateNone(),
        // Block in none state
        formDataState: defaultFormDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.blockInNoneState));
    });

    test(
        'Should return notAllow when business rule checkItemEditAllowed returns notAllow',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        formDataState: defaultFormDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) =>
            CheckAllowResult.notAllow(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        formDataState: defaultFormDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
