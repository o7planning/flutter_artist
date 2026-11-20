import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProzessMoveToPreviousStagePrecheckUtils Tests', () {
    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = ProzessMoveToPreviousStagePrecheckUtils
          .checkBeforeMoveToPreviousStage(
        checkBusy: true,
        isBusy: true,
        hasViewingStage: true,
        currentIndex: 1,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToPreviousStagePrecheck.busy),
      );
    });

    test('Should return noViewingStage when hasViewingStage is false', () {
      final result = ProzessMoveToPreviousStagePrecheckUtils
          .checkBeforeMoveToPreviousStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: false,
        currentIndex: 1,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToPreviousStagePrecheck.noViewingStage),
      );
    });

    test('Should return noPreviousStage when currentIndex is 0', () {
      final result = ProzessMoveToPreviousStagePrecheckUtils
          .checkBeforeMoveToPreviousStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: true,
        currentIndex: 0,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToPreviousStagePrecheck.noPreviousStage),
      );
    });

    test('Should return yes when a previous active stage exists', () {
      final result = ProzessMoveToPreviousStagePrecheckUtils
          .checkBeforeMoveToPreviousStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: true,
        currentIndex: 1,
      );

      expect(result.yes, isTrue);
    });
  });
}
