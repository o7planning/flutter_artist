import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProzessRestartPrecheckUtils Tests', () {
    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = ProzessRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ProzessRestartPrecheck.busy));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = ProzessRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: false,
        isBusy: true,
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when system is not busy', () {
      final result = ProzessRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
      );

      expect(result.yes, isTrue);
    });
  });
}
