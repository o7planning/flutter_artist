import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('ScalarQueryPrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = ScalarQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: true, // Hệ thống đang bận
        checkAllow: true,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarQueryPrecheck.busy));
    });

    test(
        'Should return notAllow when checkAllow is true and checkQueryAllowed returns notAllow',
        () {
      final result = ScalarQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkQueryAllowed: () => CheckAllowResult.notAllow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarQueryPrecheck.notAllow));
    });

    test(
        'Should return checkAllowMethodError when checkQueryAllowed returns an error',
        () {
      final mockErrorInfo = ErrorInfo(
        errorMessage: 'Scalar query rule error',
        errorDetails: null,
        stackTrace: null,
      );

      final result = ScalarQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkQueryAllowed: () =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ScalarQueryPrecheck.checkAllowMethodError));
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should return yes when all conditions pass successfully', () {
      final result = ScalarQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
