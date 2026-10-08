import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('StageRewindPrecheckUtils Tests', () {
    test('Returns busy precheck when global executor is busy', () {
      final result = StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
        checkBusy: true,
        isBusy: true,
        targetStageOrder: 10,
        hasTargetStage: true,
        targetStageIsSubmitted: true,
        reexecutionAllowed: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRewindPrecheck.busy));
    });

    test(
        'Returns noTargetStage when target stage does not exist or order is null',
        () {
      final result = StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: null,
        hasTargetStage: false,
        targetStageIsSubmitted: true,
        reexecutionAllowed: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRewindPrecheck.noTargetStage));
    });

    test(
        'Returns reexecutionNotAllowed when prozess config restricts re-execution',
        () {
      final result = StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        hasTargetStage: true,
        targetStageIsSubmitted: true,
        reexecutionAllowed: false, // Restricted
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRewindPrecheck.reexecutionNotAllowed));
    });

    test(
        'Returns stageNotSubmittedYet when target stage has not been completed',
        () {
      final result = StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        hasTargetStage: true,
        targetStageIsSubmitted: false, // Not yet submitted
        reexecutionAllowed: true,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageRewindPrecheck.stageNotSubmittedYet));
    });

    test('Returns success when all conditions for stage rewind are met', () {
      final result = StageRewindPrecheckUtils.checkBeforeRewindFrontierToStage(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        hasTargetStage: true,
        targetStageIsSubmitted: true,
        reexecutionAllowed: true,
      );

      expect(result.yes, isTrue);
    });
  });
}
