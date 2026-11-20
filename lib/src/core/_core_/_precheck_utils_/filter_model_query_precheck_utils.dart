part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for [FilterModel] query operations.
class FilterModelQueryPrecheckUtils {
  /// Evaluates whether executing a query from a [FilterModel] is permitted.
  static Actionable<FilterModelQueryPrecheck> checkBeforeQuery({
    required bool checkBusy,
    required bool isBusy,
  }) {
    // 1. Priority 1: Check if the system executor or filter patch lock is busy
    if (checkBusy && isBusy) {
      return Actionable<FilterModelQueryPrecheck>.no(
        errCode: FilterModelQueryPrecheck.busy,
      );
    }

    return Actionable<FilterModelQueryPrecheck>.yes();
  }
}
