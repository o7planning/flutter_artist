part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for block item deletion.
class BlockItemDeletionPrecheckUtils {
  /// Evaluates whether an item can be deleted from a block.
  static Actionable<BlockItemDeletionPrecheck> checkBeforeDeleteItem<ITEM>({
    required bool checkBusy,
    required bool isBusy,
    required bool errorIfItemNotInTheBlock,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool checkAllow,
    required ITEM? Function(ITEM targetItem) findItemSameIdWith,
    required CheckAllowResult Function(ITEM validItem) checkItemDeletionAllowed,
  }) {
    // 1. Check if the system is busy
    if (checkBusy && isBusy) {
      return Actionable<BlockItemDeletionPrecheck>.no(
        errCode: BlockItemDeletionPrecheck.busy,
      );
    }

    // 2. Check if the target item is null
    if (item == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }

    // 3. Check if the item belongs to the block
    if (errorIfItemNotInTheBlock) {
      final ITEM? foundItem = findItemSameIdWith(item);
      if (foundItem == null) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }

    // 4. Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkItemDeletionAllowed(item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemDeletionPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }

    return Actionable<BlockItemDeletionPrecheck>.yes();
  }
}
