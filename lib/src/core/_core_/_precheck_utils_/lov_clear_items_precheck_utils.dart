part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for LOV clear items operations.
class LovClearItemsPrecheckUtils {
  /// Evaluates whether clearing a LOV's items is permitted.
  static Actionable<LovClearItemsPrecheck> checkBeforeClearItems({
    required bool checkBusy,
    required bool isBusy,
    required bool hasActiveViews,
  }) {
    // 1. Check if the system is busy.
    if (checkBusy && isBusy) {
      return Actionable<LovClearItemsPrecheck>.no(
        errCode: LovClearItemsPrecheck.busy,
      );
    }

    // 2. Check if the LOV has active UI representation.
    if (hasActiveViews) {
      return Actionable<LovClearItemsPrecheck>.no(
        errCode: LovClearItemsPrecheck.hasActiveViews,
      );
    }

    return Actionable<LovClearItemsPrecheck>.yes();
  }
}
