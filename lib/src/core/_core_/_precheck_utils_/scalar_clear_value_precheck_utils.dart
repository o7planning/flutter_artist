part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for scalar clearing operations.
class ScalarClearValuePrecheckUtils {
  /// Evaluates whether clearing a scalar is permitted.
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check.
  /// - [hasActiveViews]: Ensures we don't clear scalars while their UI is actively displayed.
  static Actionable<ScalarClearValuePrecheck> checkBeforeClearValue({
    required bool checkBusy,
    required bool isBusy,
    required bool hasActiveViews,
  }) {
    if (checkBusy && isBusy) {
      return Actionable<ScalarClearValuePrecheck>.no(
        errCode: ScalarClearValuePrecheck.busy,
      );
    }

    if (hasActiveViews) {
      return Actionable<ScalarClearValuePrecheck>.no(
        errCode: ScalarClearValuePrecheck.hasActiveViews,
      );
    }

    return Actionable<ScalarClearValuePrecheck>.yes();
  }
}
