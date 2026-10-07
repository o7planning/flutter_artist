import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockSetCurrentItemPrecheckUtils Tests', () {
    final List<String> mockItemList = ['Item A', 'Item B'];

    String? mockFindItemSameIdWith(String item) {
      return mockItemList.contains(item) ? item : null;
    }

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockSetCurrentItemPrecheckUtils.checkBeforeSetItemAsCurrent<String>(
        item: 'Item A',
        checkBusy: true,
        isBusy: true,
        // System is busy
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockSetCurrentItemPrecheck.busy));
    });

    test(
        'Should return noTarget error when item is null and errCodeIfItemIsNull is noTarget',
        () {
      final result =
          BlockSetCurrentItemPrecheckUtils.checkBeforeSetItemAsCurrent<String>(
        item: null,
        checkBusy: true,
        isBusy: false,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockSetCurrentItemPrecheck.noTarget));
    });

    test('Should return invalidTarget error when item is not found in list',
        () {
      final result =
          BlockSetCurrentItemPrecheckUtils.checkBeforeSetItemAsCurrent<String>(
        item: 'NonExistentItem',
        // Item not in mockItemList
        checkBusy: true,
        isBusy: false,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockSetCurrentItemPrecheck.invalidTarget));
    });

    test(
        'Should return yes when item exists in the list and system is not busy',
        () {
      final result =
          BlockSetCurrentItemPrecheckUtils.checkBeforeSetItemAsCurrent<String>(
        item: 'Item A',
        // Valid item
        checkBusy: true,
        isBusy: false,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        findItemSameIdWith: mockFindItemSameIdWith,
      );

      expect(result.yes, isTrue);
    });
  });
}
