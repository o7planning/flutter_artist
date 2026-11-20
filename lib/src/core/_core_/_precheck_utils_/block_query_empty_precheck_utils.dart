part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block empty-query operations.
class BlockQueryEmptyPrecheckUtils {
  /// Evaluates whether executing an empty query on a block is permitted.
  static Actionable<BlockQueryEmptyPrecheck> checkBeforeQueryEmpty({
    required bool checkBusy,
    required bool isBusy,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockQueryEmptyPrecheck>.no(
        errCode: BlockQueryEmptyPrecheck.busy,
      );
    }

    return Actionable<BlockQueryEmptyPrecheck>.yes();
  }
}
