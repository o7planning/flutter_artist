part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for task form enable operations.
class TaskFormEnablePrecheckUtils {
  /// Evaluates whether the task form is permitted to be enabled for user interaction
  /// based on task execution states and underlying form data states.
  static Actionable<TaskFormEnablePrecheck> checkFormEnable({
    required bool hasForm,
    required TaskDataState taskDataState,
    required FormDataState? formDataState,
  }) {
    // 1. Priority 1: Check if form model exists
    if (!hasForm) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.noForm,
      );
    }

    // 2. Priority 2: Check Task DataState constraints (matching Stage pattern)
    if (taskDataState.isPending) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.taskInPendingState,
      );
    }

    if (taskDataState.isStale) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.taskInStaleState,
      );
    }

    // 3. Priority 3: If task was already successfully submitted, its form must remain locked (read-only).
    // (User must trigger Restart to unlock and modify again).
    if (taskDataState.isSubmissionAttemptedSuccess) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.taskAlreadySubmitted,
      );
    }

    // 4. Priority 4: Check Form DataState constraints
    if (formDataState != null) {
      if (formDataState.isNone) {
        return Actionable<TaskFormEnablePrecheck>.no(
          errCode: TaskFormEnablePrecheck.formInNoneState,
        );
      } else if (formDataState.isPending) {
        return Actionable<TaskFormEnablePrecheck>.no(
          errCode: TaskFormEnablePrecheck.formInPendingState,
        );
      } else if (formDataState.isFatalError) {
        return Actionable<TaskFormEnablePrecheck>.no(
          errCode: TaskFormEnablePrecheck.formInFatalErrorState,
        );
      } else if (formDataState.isStale) {
        return Actionable<TaskFormEnablePrecheck>.no(
          errCode: TaskFormEnablePrecheck.formInStaleState,
        );
      }
    }

    return Actionable<TaskFormEnablePrecheck>.yes();
  }
}
