import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('ScalarClearPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = ScalarClearPrecheckUtils.checkBeforeClearScalar(
        checkBusy: true,
        isBusy: true, // Hệ thống đang bận
        hasActiveViews: false, // Không có active views
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarClearPrecheck.busy));
    });

    test(
        'Should return hasActiveViews error when scalar has active UI views bound',
        () {
      final result = ScalarClearPrecheckUtils.checkBeforeClearScalar(
        checkBusy: true,
        isBusy: false,
        hasActiveViews: true, // Scalar đang hiển thị UI trên màn hình
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarClearPrecheck.hasActiveViews));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = ScalarClearPrecheckUtils.checkBeforeClearScalar(
        checkBusy: false,
        isBusy: true,
        hasActiveViews: false,
      );

      expect(result.yes, isTrue);
    });

    test(
        'Should return yes when system is not busy and no active views are present',
        () {
      final result = ScalarClearPrecheckUtils.checkBeforeClearScalar(
        checkBusy: true,
        isBusy: false, // Hệ thống rảnh rỗi
        hasActiveViews: false, // Không có UI binding
      );

      expect(result.yes, isTrue);
    });
  });
}
