part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for task form enable operations.
class TaskFormEnablePrecheckUtils {
  /// Evaluates whether the task form is permitted to be enabled.
  static Actionable<TaskFormEnablePrecheck> checkFormEnable({
    required bool hasForm,
    required bool isStateReadyForForm,
    required FormDataState? formDataState,
  }) {
    // 1. Check if form model exists
    if (!hasForm) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.noForm,
      );
    }

    // 2. Check if task state is ready for form
    if (!isStateReadyForForm) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.hostStateNotReadyForForm,
      );
    }

    // 3. Check FormDataState constraints
    if (formDataState == null) {
      return Actionable<TaskFormEnablePrecheck>.no(
        errCode: TaskFormEnablePrecheck.noForm,
      );
    }

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

    return Actionable<TaskFormEnablePrecheck>.yes();
  }
}
