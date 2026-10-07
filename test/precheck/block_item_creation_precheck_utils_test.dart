import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockItemCreationPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
        checkBusy: true,
        isBusy: true,
        // System is busy
        hasForm: true,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkCreationAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemCreationPrecheck.busy));
    });

    test(
        'Should return noForm error when creationType is form and formModel is null',
        () {
      final result = BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
        checkBusy: true,
        isBusy: false,
        hasForm: false,
        // Form model is missing
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkCreationAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemCreationPrecheck.noForm));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result = BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: const BlockDataStateNone(),
        // Block in none state
        checkAllow: true,
        checkCreationAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(BlockItemCreationPrecheck.blockInNoneState));
    });

    test(
        'Should return notAllow when business rule checkCreationAllowed returns notAllow',
        () {
      final result = BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkCreationAllowed: () =>
            CheckAllowResult.notAllow(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemCreationPrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result = BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
        checkBusy: true,
        isBusy: false,
        hasForm: true,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkCreationAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
