import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('FilterModelQueryPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = FilterModelQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(FilterModelQueryPrecheck.busy));
    });

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = FilterModelQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: false,
        isBusy: true,
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when system is not busy', () {
      final result = FilterModelQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: false,
      );

      expect(result.yes, isTrue);
    });
  });
}
