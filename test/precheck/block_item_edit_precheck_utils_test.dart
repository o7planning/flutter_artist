import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockItemEditPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: true, // System is busy
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.busy));
    });

    test('Should return noForm error when block has no form model', () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: false, // No form model configured
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.noForm));
    });

    test('Should return noTarget error when target item is null', () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: null, // No target item provided
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
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
        blockDataState: const BlockDataStateNone(), // Block in none state
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.blockInNoneState));
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: const BlockDataStatePending(), // Block in pending state
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockItemEditPrecheck.blockInPendingState),
      );
    });

    test('Should return blockInStaleState error when block is in stale state',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState:
            BlockDataStateLoadedStale.event(), // Block in stale state
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.blockInStaleState));
    });

    test(
        'Should return notAllowed when business rule checkItemEditAllowed returns notAllowed',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) =>
            CheckAllowResult.notAllowed(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemEditPrecheck.notAllowed));
    });

    test(
        'Should return checkAllowMethodError when checkItemEditAllowed returns error',
        () {
      final mockErrorInfo = ErrorInfo.fromError(
        error: Exception('Edit permission check failed'),
        stackTrace: StackTrace.current,
      );

      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockItemEditPrecheck.checkAllowMethodError),
      );
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should skip permission check and return yes when checkAllow is false',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: false,
        checkItemEditAllowed: (item) => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result =
          BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<String>(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        item: 'Test Item',
        checkAllow: true,
        checkItemEditAllowed: (item) => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
