import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('StageFormEnablePrecheckUtils Tests', () {
    test('Returns busy precheck when executor is busy', () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: true,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormEnablePrecheck.busy));
    });

    test('Returns noForm when stage has no form model', () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: false,
        // No form attached
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormEnablePrecheck.noForm));
    });

    test('Returns noTargetStage when targetStageOrder is null', () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: null,
        // Null target order
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormEnablePrecheck.noTargetStage));
    });

    test(
        'Returns isNotViewingStage when target order does not match viewing order (e.g. stepping back to previous stage)',
        () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 20,
        // Viewing stage is 20, but target stage is 10 (mismatched)
        hasForm: true,
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormEnablePrecheck.isNotViewingStage));
    });

    test('Returns stageInPendingState when target stage is pending', () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: StageDataStatePending(),
        // Pending state
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(StageFormEnablePrecheck.stageInPendingState));
    });

    test(
        'Returns stageAlreadySubmitted when target stage has already been successfully submitted',
        () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: StageDataStateSubmissionAttemptedSuccess(),
        // Already submitted
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(StageFormEnablePrecheck.stageAlreadySubmitted));
    });

    test('Returns formInPendingState when underlying form model is pending',
        () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: const FormDataStatePending(), // Form is pending
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(StageFormEnablePrecheck.formInPendingState));
    });

    test('Returns success when all precheck constraints are fully satisfied',
        () {
      final result = StageFormEnablePrecheckUtils.checkFormEnable(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: const StageDataStateLoadedFresh(),
        targetFormDataState: const FormDataStateLoadedFresh(),
      );

      expect(result.yes, isTrue);
    });
  });
}
