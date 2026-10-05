part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block clear items operations.
class BlockClearItemsPrecheckUtils {
  /// Evaluates whether clearing a block's items is permitted.
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check.
  /// - [hasActiveViews]: Ensures we don't clear block items while their UI is actively displayed.
  static Actionable<BlockClearItemsPrecheck> checkBeforeClearItems({
    required bool checkBusy,
    required bool isBusy,
    required bool hasActiveViews,
  }) {
    // 1. Check if the system is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockClearItemsPrecheck>.no(
        errCode: BlockClearItemsPrecheck.busy,
      );
    }

    // 2. Check if the block has active UI representation
    if (hasActiveViews) {
      return Actionable<BlockClearItemsPrecheck>.no(
        errCode: BlockClearItemsPrecheck.hasActiveViews,
      );
    }

    return Actionable<BlockClearItemsPrecheck>.yes();
  }
}
