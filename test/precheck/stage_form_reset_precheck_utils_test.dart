import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StageFormResetPrecheckUtils Tests', () {
    const freshStage = StageDataStateLoadedFresh();
    const freshForm = FormDataStateLoadedFresh();

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: true,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.busy));
    });

    test('Should return noViewingStage when target or viewing order is null',
        () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: null,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.noViewingStage));
    });

    test('Should return isNotViewingStage when orders do not match', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 20,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.isNotViewingStage));
    });

    test('Should return noForm when hasForm is false', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: false,
        targetStageDataState: freshStage,
        targetFormDataState: null,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.noForm));
    });

    test('Should return stageNotReady when stage is pending', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: const StageDataStatePending(),
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.stageNotReady));
    });

    test('Should return formDataNotLoaded when form is not loaded fresh', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: const FormDataStatePending(),
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.formDataNotLoaded));
    });

    test('Should return formIsNotDirty when isDirty is false', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: false,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.formIsNotDirty));
    });

    test(
        'Should return notAllowed when checkFormResetAllowed returns notAllowed',
        () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(StageFormResetPrecheck.notAllowed));
    });

    test('Should return yes when all conditions pass', () {
      final result = StageFormResetPrecheckUtils.checkBeforeResetForm(
        checkBusy: true,
        isBusy: false,
        targetStageOrder: 10,
        viewingStageOrder: 10,
        hasForm: true,
        targetStageDataState: freshStage,
        targetFormDataState: freshForm,
        isDirty: true,
        checkAllow: true,
        checkFormResetAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
