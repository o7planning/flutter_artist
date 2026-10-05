part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for scalar queries.
class ScalarQueryPrecheckUtils {
  /// Evaluates whether a scalar is permitted to execute a query.
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check first.
  /// - [checkAllow] & [checkQueryAllowed]: Evaluates business permission rules.
  static Actionable<ScalarQueryPrecheck> checkBeforeQuery({
    required bool checkBusy,
    required bool isBusy,
    required bool checkAllow,
    required CheckAllowResult Function() checkQueryAllowed,
  }) {
    // 1. Priority 1: Always check if the system is busy first
    if (checkBusy && isBusy) {
      return Actionable<ScalarQueryPrecheck>.no(
        errCode: ScalarQueryPrecheck.busy,
      );
    }

    // 2. Priority 2: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<ScalarQueryPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<ScalarQueryPrecheck>.no(
            errCode: ScalarQueryPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<ScalarQueryPrecheck>.no(
            errCode: ScalarQueryPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<ScalarQueryPrecheck>.yes();
  }
}
