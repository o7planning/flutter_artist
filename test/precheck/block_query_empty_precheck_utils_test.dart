import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockQueryEmptyPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = BlockQueryEmptyPrecheckUtils.checkBeforeQueryEmpty(
        checkBusy: true,
        isBusy: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQueryEmptyPrecheck.busy));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = BlockQueryEmptyPrecheckUtils.checkBeforeQueryEmpty(
        checkBusy: false,
        isBusy: true,
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when system is not busy', () {
      final result = BlockQueryEmptyPrecheckUtils.checkBeforeQueryEmpty(
        checkBusy: true,
        isBusy: false,
      );

      expect(result.yes, isTrue);
    });
  });
}
