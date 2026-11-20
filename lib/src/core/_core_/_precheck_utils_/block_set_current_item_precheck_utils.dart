part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block set item as current operations.
class BlockSetCurrentItemPrecheckUtils {
  /// Evaluates whether setting an item as current is permitted.
  static Actionable<BlockSetCurrentItemPrecheck>
      checkBeforeSetItemAsCurrent<ITEM>({
    required ITEM? item,
    required bool checkBusy,
    required bool isBusy,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required ITEM? Function(ITEM targetItem) findItemSameIdWith,
  }) {
    // 1. Priority 1: Check if the system executor is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.busy,
      );
    }

    // 2. Priority 2: Check if the target item is null
    if (item == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.invalidTarget,
        );
      }
    }

    // 3. Priority 3: Check if the item exists in the block's current list
    // Test Cases: [03b].
    final ITEM? foundItem = findItemSameIdWith(item);
    if (foundItem == null) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.invalidTarget,
      );
    }

    return Actionable<BlockSetCurrentItemPrecheck>.yes();
  }
}
