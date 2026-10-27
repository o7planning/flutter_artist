part of '__precheck_utils.dart';

class TaskRestartPrecheckUtils {
  /// Evaluates whether the task is permitted to load or reload its initial data
  /// based on system business rules, task state, and dynamic configuration.
  static Actionable<TaskRestartPrecheck> checkBeforeRestart({
    required bool checkBusy,
    required bool isBusy,
    required bool checkAllow,
    required TaskDataState taskDataState,
    // The dynamic flag computed from the previous INIT_DATA (if any)
    required bool isReexecutionAllowed,
    required CheckAllowResult Function() checkRestartAllowed,
  }) {
    // 1. Check system execution busyness
    if (checkBusy && isBusy) {
      return Actionable<TaskRestartPrecheck>.no(
        errCode: TaskRestartPrecheck.busy,
      );
    }

    // 2. States: isPending, isLoadedStale
    // If the task allows 'stale' (e.g., due to an event) or is loading for the first time,
    // it implicitly permits fetching initial data without checking re-execution rules.
    if (taskDataState.isPending || taskDataState.isLoadedStale) {
      return Actionable<TaskRestartPrecheck>.yes();
    }

    // 3. Now taskDataState >= Fresh (LoadedFresh, SubmissionSuccess, SubmissionFailed).
    // Since it already has data, restarting it requires explicit re-execution permission.
    if (!isReexecutionAllowed) {
      if (taskDataState.isCompleted) {
        return Actionable<TaskRestartPrecheck>.no(
          errCode: TaskRestartPrecheck.restrictedBySubmitted,
        );
      } else {
        return Actionable<TaskRestartPrecheck>.no(
          errCode: TaskRestartPrecheck.reloadRestrictedByConfig,
        );
      }
    }

    // 4. Check explicit business permission rules defined by the developer
    if (checkAllow) {
      final CheckAllowResult result = checkRestartAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<TaskRestartPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<TaskRestartPrecheck>.no(
            errCode: TaskRestartPrecheck.notAllowed,
          );
        case CheckAllow.error:
          return Actionable<TaskRestartPrecheck>.no(
            errCode: TaskRestartPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<TaskRestartPrecheck>.yes();
  }
}
