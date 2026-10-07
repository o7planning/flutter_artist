import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockQuickItemCreationPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockQuickItemCreationPrecheckUtils.checkBeforeQuickCreateItem(
        checkBusy: true,
        isBusy: true,
        // System is busy
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkQuickCreateAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemCreationPrecheck.busy));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result =
          BlockQuickItemCreationPrecheckUtils.checkBeforeQuickCreateItem(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStateNone(),
        // Block in none state
        checkAllow: true,
        checkQuickCreateAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockQuickItemCreationPrecheck.blockInNoneState));
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockQuickItemCreationPrecheckUtils.checkBeforeQuickCreateItem(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStatePending(),
        // Block in pending state
        checkAllow: true,
        checkQuickCreateAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockQuickItemCreationPrecheck.blockInPendingState));
    });

    test(
        'Should return notAllow when business rule checkQuickCreateAllowed returns notAllow',
        () {
      final result =
          BlockQuickItemCreationPrecheckUtils.checkBeforeQuickCreateItem(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkQuickCreateAllowed: () =>
            CheckAllowResult.notAllow(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemCreationPrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result =
          BlockQuickItemCreationPrecheckUtils.checkBeforeQuickCreateItem(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkQuickCreateAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
