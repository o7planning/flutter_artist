import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('StageSubmitPrecheckUtils Tests', () {
    test('Returns busy precheck when executor is busy', () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: true,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        targetStageDataState: const StageDataStateLoadedFresh(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageSubmitPrecheck.busy));
    });

    test('Returns noTargetStage when targetStageOrder is null', () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: null,
        viewingStageOrder: 10,
        targetStageDataState: const StageDataStateLoadedFresh(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageSubmitPrecheck.noTargetStage));
    });

    test(
        'Returns isNotViewingStage when target order does not match viewing order',
        () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 20,
        // Mismatched viewing stage
        targetStageDataState: const StageDataStateLoadedFresh(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageSubmitPrecheck.isNotViewingStage));
    });

    test('Returns stageInPendingState when target stage is pending', () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        targetStageDataState: StageDataStatePending(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageSubmitPrecheck.stageInPendingState));
    });

    test(
        'Returns stageAlreadySubmitted when target stage has already been successfully submitted',
        () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        targetStageDataState: StageDataStateSubmissionSuccess(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageSubmitPrecheck.stageAlreadySubmitted));
    });

    test('Returns success when all precheck constraints are satisfied', () {
      final result = StageSubmitPrecheckUtils.checkBeforeSubmit(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        targetStageDataState: const StageDataStateLoadedFresh(),
        checkTargetFormValidate: false,
        hasTargetForm: false,
        targetFormDataState: null,
        getActiveFormStates: null,
      );

      expect(result.yes, isTrue);
    });
  });
}
