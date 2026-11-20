part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block current item refresh operations.
class BlockRefreshCurrentItemPrecheckUtils {
  /// Evaluates whether refreshing the active current item is permitted.
  static Actionable<BlockRefreshCurrentItemPrecheck>
      checkBeforeRefreshCurrentItem<ITEM>({
    required ITEM? currentItem,
    required bool checkBusy,
    required bool isBusy,
    required ITEM? Function(ITEM targetItem) findItemSameIdWith,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockRefreshCurrentItemPrecheck>.no(
        errCode: BlockRefreshCurrentItemPrecheck.busy,
      );
    }

    // 2. Priority 2: Check if there is an active current item
    if (currentItem == null) {
      return Actionable<BlockRefreshCurrentItemPrecheck>.no(
        errCode: BlockRefreshCurrentItemPrecheck.noTarget,
      );
    }

    // 3. Priority 3: Check if the current item still exists in the block's list
    final ITEM? foundItem = findItemSameIdWith(currentItem);
    if (foundItem == null) {
      return Actionable<BlockRefreshCurrentItemPrecheck>.no(
        errCode: BlockRefreshCurrentItemPrecheck.invalidTarget,
      );
    }

    return Actionable<BlockRefreshCurrentItemPrecheck>.yes();
  }
}
