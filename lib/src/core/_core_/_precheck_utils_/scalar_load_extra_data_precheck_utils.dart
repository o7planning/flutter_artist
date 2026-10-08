part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for scalar load extra data operations.
class ScalarLoadExtraDataPrecheckUtils {
  /// Evaluates whether loading extra data for a scalar is permitted.
  static Actionable<ScalarLoadExtraDataPrecheck> checkBeforeLoadExtraData({
    required bool checkBusy,
    required bool isBusy,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<ScalarLoadExtraDataPrecheck>.no(
        errCode: ScalarLoadExtraDataPrecheck.busy,
      );
    }

    return Actionable<ScalarLoadExtraDataPrecheck>.yes();
  }
}
