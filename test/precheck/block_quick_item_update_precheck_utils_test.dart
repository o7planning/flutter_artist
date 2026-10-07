import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockQuickItemUpdatePrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();
    const testItem = 'Item A';
    final List<String> mockItemList = [testItem, 'Item B'];

    // Hàm giả lập kiểm tra item có nằm trong danh sách hay không
    bool mockContainsItem(String item) => mockItemList.contains(item);

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: true,
        // System is busy
        blockDataState: defaultBlockDataState,
        item: testItem,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.busy));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStateNone(),
        // Block in none state
        item: testItem,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockQuickItemUpdatePrecheck.blockInNoneState));
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStatePending(),
        // Block in pending state
        item: testItem,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockQuickItemUpdatePrecheck.blockInPendingState));
    });

    test('Should return noTarget error when item is null', () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: null,
        // Target item is null
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.noTarget));
    });

    test(
        'Should return invalidTarget error when item does not exist in the list',
        () {
      const nonExistentItem = 'Item X';

      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: nonExistentItem,
        // Item not in list
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(BlockQuickItemUpdatePrecheck.invalidTarget));
    });

    test(
        'Should return notAllow when business rule checkQuickUpdateAllowed returns notAllow',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) =>
            CheckAllowResult.notAllow(), // Disallowed by business rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.notAllow));
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: (item) => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
