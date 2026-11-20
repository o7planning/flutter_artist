import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProzessMoveToNextStagePrecheckUtils Tests', () {
    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result =
          ProzessMoveToNextStagePrecheckUtils.checkBeforeMoveToNextStage(
        checkBusy: true,
        isBusy: true,
        hasViewingStage: true,
        currentIndex: 0,
        activeStagesCount: 3,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ProzessMoveToNextStagePrecheck.busy));
    });

    test('Should return noViewingStage when hasViewingStage is false', () {
      final result =
          ProzessMoveToNextStagePrecheckUtils.checkBeforeMoveToNextStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: false,
        currentIndex: 0,
        activeStagesCount: 3,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToNextStagePrecheck.noViewingStage),
      );
    });

    test('Should return noViewingStage when currentIndex is negative', () {
      final result =
          ProzessMoveToNextStagePrecheckUtils.checkBeforeMoveToNextStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: true,
        currentIndex: -1,
        activeStagesCount: 3,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToNextStagePrecheck.noViewingStage),
      );
    });

    test('Should return noNextStage when currentIndex is at the last stage',
        () {
      final result =
          ProzessMoveToNextStagePrecheckUtils.checkBeforeMoveToNextStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: true,
        currentIndex: 2,
        activeStagesCount: 3,
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(ProzessMoveToNextStagePrecheck.noNextStage),
      );
    });

    test('Should return yes when a next active stage exists', () {
      final result =
          ProzessMoveToNextStagePrecheckUtils.checkBeforeMoveToNextStage(
        checkBusy: true,
        isBusy: false,
        hasViewingStage: true,
        currentIndex: 0,
        activeStagesCount: 3,
      );

      expect(result.yes, isTrue);
    });
  });
}
