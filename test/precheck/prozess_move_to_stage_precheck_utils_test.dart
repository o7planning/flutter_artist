import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProzessMoveToStagePrecheckUtils Tests', () {
    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result = ProzessMoveToStagePrecheckUtils.checkBeforeMoveToStage(
        checkBusy: true,
        isBusy: true,
        isTargetStageInActiveRoute: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(ProzessMoveToStagePrecheck.busy));
    });

    test(
      'Should return stageNotInActiveRoute when target stage is not in active route',
      () {
        final result = ProzessMoveToStagePrecheckUtils.checkBeforeMoveToStage(
          checkBusy: true,
          isBusy: false,
          isTargetStageInActiveRoute: false,
        );

        expect(result.yes, isFalse);
        expect(
          result.errCode,
          equals(ProzessMoveToStagePrecheck.stageNotInActiveRoute),
        );
      },
    );

    test('Should return yes when checkBusy is false even if isBusy is true',
        () {
      final result = ProzessMoveToStagePrecheckUtils.checkBeforeMoveToStage(
        checkBusy: false,
        isBusy: true,
        isTargetStageInActiveRoute: true,
      );

      expect(result.yes, isTrue);
    });

    test(
      'Should return yes when system is free and target stage is in active route',
      () {
        final result = ProzessMoveToStagePrecheckUtils.checkBeforeMoveToStage(
          checkBusy: true,
          isBusy: false,
          isTargetStageInActiveRoute: true,
        );

        expect(result.yes, isTrue);
      },
    );
  });
}
