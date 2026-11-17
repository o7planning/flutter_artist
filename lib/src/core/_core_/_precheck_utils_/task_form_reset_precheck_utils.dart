part of '__precheck_utils.dart';

/// Utility class providing standalone precheck validation for resetting
/// a [TaskFormModel].
class TaskFormResetPrecheckUtils {
  /// Evaluates whether the task form can be reset to its initial state.
  static Actionable<TaskFormResetPrecheck> checkBeforeResetForm({
    required bool checkBusy,
    required bool isBusy,
    required bool hasForm,
    required TaskDataState taskDataState,
    required FormDataState? formDataState,
    required bool isDirty,
    required bool checkAllow,
    required CheckAllowResult Function() checkFormResetAllowed,
  }) {
    if (checkBusy && isBusy) {
      return Actionable.no(
        errCode: TaskFormResetPrecheck.executorIsBusy,
      );
    }

    if (!hasForm) {
      return Actionable.no(
        errCode: TaskFormResetPrecheck.noForm,
      );
    }

    if (taskDataState.isPending || taskDataState.isLoadedStale) {
      return Actionable.no(
        errCode: TaskFormResetPrecheck.taskNotReady,
      );
    }

    if (formDataState == null || !formDataState.isLoadedFresh) {
      return Actionable.no(
        errCode: TaskFormResetPrecheck.formDataNotLoaded,
      );
    }

    if (!isDirty) {
      return Actionable.no(
        errCode: TaskFormResetPrecheck.formNotDirty,
      );
    }

    if (checkAllow) {
      final CheckAllowResult allowResult = checkFormResetAllowed();
      if (allowResult.isError) {
        return Actionable.no(
          errCode: TaskFormResetPrecheck.allowCheckError,
          errorInfo: allowResult.errorInfo,
        );
      }
      if (!allowResult.isAllowed) {
        return Actionable.no(
          errCode: TaskFormResetPrecheck.notAllowed,
        );
      }
    }

    return Actionable.yes();
  }
}
