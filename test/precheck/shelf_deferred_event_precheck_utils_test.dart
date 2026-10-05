import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('ShelfDeferredEventPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = ShelfDeferredEventPrecheckUtils
          .checkBeforeExecuteDelayedExternalReaction(
        checkBusy: true,
        isBusy: true, // Hệ thống đang bận
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ShelfDeferredEventExecutionPrecheck.busy));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = ShelfDeferredEventPrecheckUtils
          .checkBeforeExecuteDelayedExternalReaction(
        checkBusy: false,
        isBusy: true,
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when system is not busy', () {
      final result = ShelfDeferredEventPrecheckUtils
          .checkBeforeExecuteDelayedExternalReaction(
        checkBusy: true,
        isBusy: false, // Hệ thống rảnh rỗi
      );

      expect(result.yes, isTrue);
    });
  });
}
