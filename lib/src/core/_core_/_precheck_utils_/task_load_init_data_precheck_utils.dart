part of '__precheck_utils.dart';

class TaskLoadInitDataPrecheckUtils {
  /// Evaluates whether the task is permitted to load or reload its initial data
  /// based on system business rules, task state, and effective configuration.
  static Actionable<TaskLoadInitDataPrecheck> checkBeforeLoadInitData({
    required bool checkBusy,
    required bool isBusy,
    required bool checkAllow,
    required TaskDataState taskDataState,
    // When the task is fresh and the user attempts to reload initial data.
    required bool allowReloadInitDataOnFresh,
    required bool allowMultipleSubmissions,
    required CheckAllowResult Function() checkLoadInitDataAllowed,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<TaskLoadInitDataPrecheck>.no(
        errCode: TaskLoadInitDataPrecheck.busy,
      );
    }

    // States: isPending, isFresh, isStale, isSubmissionAttemptedSuccess, isSubmissionAttemptedFailed.
    // If the task allows 'stale' (e.g., due to an event), it implicitly permits reloading initial data.
    if (taskDataState.isPending || taskDataState.isStale) {
      return Actionable<TaskLoadInitDataPrecheck>.yes();
    }

    // Now taskDataState >= Fresh.
    if (!allowReloadInitDataOnFresh) {
      return Actionable<TaskLoadInitDataPrecheck>.no(
        errCode: TaskLoadInitDataPrecheck.reloadRestrictedByConfig,
      );
    }

    if (taskDataState.isSubmissionAttemptedSuccess) {
      if (!allowMultipleSubmissions) {
        return Actionable<TaskLoadInitDataPrecheck>.no(
          errCode: TaskLoadInitDataPrecheck.restrictedBySubmitted,
        );
      }
    }

    // Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkLoadInitDataAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<TaskLoadInitDataPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<TaskLoadInitDataPrecheck>.no(
            errCode: TaskLoadInitDataPrecheck.notAllowed,
          );
        case CheckAllow.error:
          return Actionable<TaskLoadInitDataPrecheck>.no(
            errCode: TaskLoadInitDataPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<TaskLoadInitDataPrecheck>.yes();
  }
}
