part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for stage submission operations
/// driven by viewing constraints and stage data states.
class StageSubmitPrecheckUtils {
  /// Evaluates whether a stage is permitted to be submitted based on viewing focus,
  /// stage execution states, and form validation results.
  static Actionable<StageSubmitPrecheck> checkBeforeSubmit({
    required bool checkBusy,
    required bool isBusy,
    required int? targetStageOrder,
    required int? viewingStageOrder,
    required StageDataState targetStageDataState,
    required bool checkTargetFormValidate,
    required bool hasTargetForm,
    required FormDataState? targetFormDataState,
    required List<dynamic> Function()? getActiveFormStates,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.busy,
      );
    }

    // 2. Priority 2: Ensure target stage order is specified
    if (targetStageOrder == null) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.noTargetStage,
      );
    }

    // 3. Priority 3: Ensure target stage is currently the active viewing stage
    if (targetStageOrder != viewingStageOrder) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.isNotViewingStage,
      );
    }

    // 4. Priority 4: Evaluate Stage DataState to control submission behavior cleanly
    if (targetStageDataState.isPending) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.stageInPendingState,
      );
    }

    if (targetStageDataState.isLoadedStale) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.stageInStaleState,
      );
    }

    if (targetStageDataState.isSubmissionSuccess) {
      return Actionable<StageSubmitPrecheck>.no(
        errCode: StageSubmitPrecheck.stageAlreadySubmitted,
      );
    }

    // 5. Priority 5: Check Form constraints (if formModel exists)
    if (hasTargetForm && targetFormDataState != null) {
      if (targetFormDataState.isNone) {
        return Actionable<StageSubmitPrecheck>.no(
          errCode: StageSubmitPrecheck.formInNoneState,
        );
      } else if (targetFormDataState.isPending) {
        return Actionable<StageSubmitPrecheck>.no(
          errCode: StageSubmitPrecheck.formInPendingState,
        );
      } else if (targetFormDataState.isFatalError) {
        return Actionable<StageSubmitPrecheck>.no(
          errCode: StageSubmitPrecheck.formInFatalErrorState,
        );
      } else if (targetFormDataState.isLoadedStale) {
        return Actionable<StageSubmitPrecheck>.no(
          errCode: StageSubmitPrecheck.formInStaleState,
        );
      }

      // 6. Priority 6: Validate active UI form fields if requested
      if (checkTargetFormValidate && getActiveFormStates != null) {
        final List<dynamic> activeForms = getActiveFormStates();
        bool allFormsAreValid = true;
        for (final formState in activeForms) {
          bool isValid = formState.validate(focusOnInvalid: false);
          allFormsAreValid = allFormsAreValid && isValid;
        }
        if (!allFormsAreValid) {
          return Actionable<StageSubmitPrecheck>.no(
            errCode: StageSubmitPrecheck.formInvalidated,
          );
        }
      }
    }

    return Actionable<StageSubmitPrecheck>.yes();
  }
}
