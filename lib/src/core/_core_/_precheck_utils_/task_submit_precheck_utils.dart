part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for task submission operations.
class TaskSubmitPrecheckUtils {
  /// Evaluates whether a task is permitted to be submitted based on task states,
  /// form data states, and active form validation results.
  static Actionable<TaskSubmitPrecheck> checkBeforeSubmit({
    required bool checkBusy,
    required bool isBusy,
    required bool checkAllow, // reserved or passed for consistency if needed
    required bool checkValidate,
    required TaskDataState taskDataState,
    required bool hasForm,
    required FormDataState? formDataState,
    required List<dynamic> Function()? getActiveFormStates,
  }) {
    // 1. Priority 1: Check if the global executor is busy
    if (checkBusy && isBusy) {
      return Actionable<TaskSubmitPrecheck>.no(
        errCode: TaskSubmitPrecheck.busy,
      );
    }

    // 2. Priority 2: Check Task DataState constraints
    if (taskDataState.isPending) {
      return Actionable<TaskSubmitPrecheck>.no(
        errCode: TaskSubmitPrecheck.taskInPendingState,
      );
    }

    if (taskDataState.isStale) {
      return Actionable<TaskSubmitPrecheck>.no(
        errCode: TaskSubmitPrecheck.taskInStaleState,
      );
    }

    if (taskDataState.isSubmissionAttemptedSuccess) {
      return Actionable<TaskSubmitPrecheck>.no(
        errCode: TaskSubmitPrecheck.taskAlreadySubmitted,
      );
    }

    // 3. Priority 3: Check Form constraints (if formModel exists)
    if (hasForm && formDataState != null) {
      if (formDataState.isNone) {
        return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.formInNoneState,
        );
      } else if (formDataState.isPending) {
        return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.formInPendingState,
        );
      } else if (formDataState.isFatalError) {
        return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.formInFatalErrorState,
        );
      } else if (formDataState.isStale) {
        return Actionable<TaskSubmitPrecheck>.no(
          errCode: TaskSubmitPrecheck.formInStaleState,
        );
      }

      // 4. Priority 4: Validate active UI form fields if requested
      if (checkValidate && getActiveFormStates != null) {
        final List<dynamic> activeForms = getActiveFormStates();
        bool allFormsAreValid = true;
        for (final formState in activeForms) {
          // Giả định formState có hàm validate(bool focusOnInvalid) như FormBuilderState
          bool isValid = formState.validate(focusOnInvalid: false);
          allFormsAreValid = allFormsAreValid && isValid;
        }
        if (!allFormsAreValid) {
          return Actionable<TaskSubmitPrecheck>.no(
            errCode: TaskSubmitPrecheck.formInvalidated,
          );
        }
      }
    }

    return Actionable<TaskSubmitPrecheck>.yes();
  }
}
