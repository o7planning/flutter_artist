import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockRefreshCurrentItemPrecheckUtils Tests', () {
    const testItem = 'Item A';
    final List<String> mockItemList = [testItem, 'Item B'];

    String? mockFindItemSameIdWith(String targetItem) {
      return mockItemList.contains(targetItem) ? targetItem : null;
    }

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockRefreshCurrentItemPrecheckUtils
          .checkBeforeRefreshCurrentItem<String>(
        currentItem: testItem,
        checkBusy: true,
        isBusy: true,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockRefreshCurrentItemPrecheck.busy));
    });

    test('Should return noTarget error when currentItem is null', () {
      final result = BlockRefreshCurrentItemPrecheckUtils
          .checkBeforeRefreshCurrentItem<String>(
        currentItem: null,
        checkBusy: true,
        isBusy: false,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockRefreshCurrentItemPrecheck.noTarget));
    });

    test(
        'Should return invalidTarget error when currentItem does not exist in the list',
        () {
      const missingItem = 'Item X';

      final result = BlockRefreshCurrentItemPrecheckUtils
          .checkBeforeRefreshCurrentItem<String>(
        currentItem: missingItem,
        checkBusy: true,
        isBusy: false,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockRefreshCurrentItemPrecheck.invalidTarget),
      );
    });

    test('Should return yes when system is free and currentItem is in the list',
        () {
      final result = BlockRefreshCurrentItemPrecheckUtils
          .checkBeforeRefreshCurrentItem<String>(
        currentItem: testItem,
        checkBusy: true,
        isBusy: false,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isTrue);
    });
  });
}
