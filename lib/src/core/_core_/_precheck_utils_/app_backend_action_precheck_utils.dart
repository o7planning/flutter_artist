part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for application backend action operations.
class AppBackendActionPrecheckUtils {
  /// Evaluates whether executing an application backend action is permitted.
  static Actionable<AppBackendActionPrecheck>
      checkBeforeExecuteAppBackendAction({
    required bool checkBusy,
    required bool isBusy,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<AppBackendActionPrecheck>.no(
        errCode: AppBackendActionPrecheck.busy,
      );
    }

    return Actionable<AppBackendActionPrecheck>.yes();
  }
}
