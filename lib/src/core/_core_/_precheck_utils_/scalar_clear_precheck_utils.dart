part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for scalar clearing operations.
class ScalarClearPrecheckUtils {
  /// Evaluates whether clearing a scalar is permitted.
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check.
  /// - [hasActiveViews]: Ensures we don't clear scalars while their UI is actively displayed.
  static Actionable<ScalarClearPrecheck> checkBeforeClearScalar({
    required bool checkBusy,
    required bool isBusy,
    required bool hasActiveViews,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<ScalarClearPrecheck>.no(
        errCode: ScalarClearPrecheck.busy,
      );
    }

    if (hasActiveViews) {
      return Actionable<ScalarClearPrecheck>.no(
        errCode: ScalarClearPrecheck.hasActiveViews,
      );
    }

    return Actionable<ScalarClearPrecheck>.yes();
  }
}
