import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockClearCurrentItemPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockClearCurrentItemPrecheckUtils
          .checkBeforeClearCurrentItem<String>(
        checkBusy: true,
        isBusy: true,
        currentItem: 'Item A',
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockClearCurrentItemPrecheck.busy));
    });

    test('Should return noTarget error when currentItem is null', () {
      final result = BlockClearCurrentItemPrecheckUtils
          .checkBeforeClearCurrentItem<String>(
        checkBusy: true,
        isBusy: false,
        currentItem: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockClearCurrentItemPrecheck.noTarget));
    });

    test('Should return yes when system is free and currentItem is present',
        () {
      final result = BlockClearCurrentItemPrecheckUtils
          .checkBeforeClearCurrentItem<String>(
        checkBusy: true,
        isBusy: false,
        currentItem: 'Item A',
      );

      expect(result.yes, isTrue);
    });
  });
}
