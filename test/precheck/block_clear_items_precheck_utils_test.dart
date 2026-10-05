import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockClearItemsPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockClearItemsPrecheckUtils.checkBeforeClearItems(
        checkBusy: true,
        isBusy: true, // Hệ thống đang bận
        hasActiveViews: false, // Không có active views
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockClearItemsPrecheck.busy));
    });

    test('Should return hasActiveViews error when block has active UI context',
        () {
      final result = BlockClearItemsPrecheckUtils.checkBeforeClearItems(
        checkBusy: true,
        isBusy: false,
        hasActiveViews: true, // Block đang hiển thị UI
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockClearItemsPrecheck.hasActiveViews));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = BlockClearItemsPrecheckUtils.checkBeforeClearItems(
        checkBusy: false,
        isBusy: true,
        hasActiveViews: false,
      );

      expect(result.yes, isTrue);
    });

    test(
        'Should return yes when system is not busy and no active views are present',
        () {
      final result = BlockClearItemsPrecheckUtils.checkBeforeClearItems(
        checkBusy: true,
        isBusy: false, // Hệ thống rảnh rỗi
        hasActiveViews: false, // Không có UI binding
      );

      expect(result.yes, isTrue);
    });
  });
}
