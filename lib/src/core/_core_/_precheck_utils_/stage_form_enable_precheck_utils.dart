part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for stage form enable operations.
class StageFormEnablePrecheckUtils {
  /// Evaluates whether a stage form is permitted to be enabled for user interaction
  /// based on viewing focus, stage execution states, and underlying form data states.
  static Actionable<StageFormEnablePrecheck> checkFormEnable({
    required bool checkBusy,
    required bool isBusy,
    required int? targetStageOrder,
    required int? viewingStageOrder,
    required bool hasForm,
    required StageDataState targetStageDataState,
    required FormDataState? targetFormDataState,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.busy,
      );
    }

    // 2. Priority 2: Ensure form model exists
    if (!hasForm) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.noForm,
      );
    }

    // 3. Priority 3: Ensure target stage order is specified
    if (targetStageOrder == null) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.noTargetStage,
      );
    }

    // 4. Priority 4: Ensure target stage is currently the active viewing stage.
    // (This locks forms of background, past, or future stages when navigating back/forward).
    if (targetStageOrder != viewingStageOrder) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.isNotViewingStage,
      );
    }

    // 5. Priority 5: Check Stage DataState constraints
    if (targetStageDataState.isPending) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.stageInPendingState,
      );
    }

    if (targetStageDataState.isStale) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.stageInStaleState,
      );
    }

    // 6. Priority 6: If stage was already successfully submitted, its form must remain locked (read-only).
    if (targetStageDataState.isSubmissionAttemptedSuccess) {
      return Actionable<StageFormEnablePrecheck>.no(
        errCode: StageFormEnablePrecheck.stageAlreadySubmitted,
      );
    }

    // 7. Priority 7: Check Form DataState constraints
    if (targetFormDataState != null) {
      if (targetFormDataState.isNone) {
        return Actionable<StageFormEnablePrecheck>.no(
          errCode: StageFormEnablePrecheck.formInNoneState,
        );
      } else if (targetFormDataState.isPending) {
        return Actionable<StageFormEnablePrecheck>.no(
          errCode: StageFormEnablePrecheck.formInPendingState,
        );
      } else if (targetFormDataState.isFatalError) {
        return Actionable<StageFormEnablePrecheck>.no(
          errCode: StageFormEnablePrecheck.formInFatalErrorState,
        );
      } else if (targetFormDataState.isStale) {
        return Actionable<StageFormEnablePrecheck>.no(
          errCode: StageFormEnablePrecheck.formInStaleState,
        );
      }
    }

    return Actionable<StageFormEnablePrecheck>.yes();
  }
}
