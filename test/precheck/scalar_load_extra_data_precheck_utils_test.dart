import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('ScalarLoadExtraDataPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = ScalarLoadExtraDataPrecheckUtils.checkBeforeLoadExtraData(
        checkBusy: true,
        isBusy: true, // System is busy
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarLoadExtraDataPrecheck.busy));
    });

    test('Should return yes when checkBusy is true but system is not busy', () {
      final result = ScalarLoadExtraDataPrecheckUtils.checkBeforeLoadExtraData(
        checkBusy: true,
        isBusy: false, // System is free
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when checkBusy is false even if system is busy',
        () {
      final result = ScalarLoadExtraDataPrecheckUtils.checkBeforeLoadExtraData(
        checkBusy: false,
        isBusy: true, // System is busy, but checkBusy is disabled
      );

      expect(result.yes, isTrue);
    });
  });
}
