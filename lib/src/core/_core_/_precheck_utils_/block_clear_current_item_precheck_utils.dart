part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for clearing a block's current item.
class BlockClearCurrentItemPrecheckUtils {
  /// Evaluates whether clearing the active current item is permitted.
  static Actionable<BlockClearCurrentItemPrecheck>
      checkBeforeClearCurrentItem<ITEM>({
    required bool checkBusy,
    required bool isBusy,
    required ITEM? currentItem,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockClearCurrentItemPrecheck>.no(
        errCode: BlockClearCurrentItemPrecheck.busy,
      );
    }

    // 2. Priority 2: Check if there is an active current item
    if (currentItem == null) {
      return Actionable<BlockClearCurrentItemPrecheck>.no(
        errCode: BlockClearCurrentItemPrecheck.noTarget,
      );
    }

    return Actionable<BlockClearCurrentItemPrecheck>.yes();
  }
}
