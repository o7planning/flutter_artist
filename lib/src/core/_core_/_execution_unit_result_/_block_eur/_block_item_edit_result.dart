part of '../../core.dart';

/// Execution unit result representing the outcome of preparing a [BlockFormModel]
/// to edit an existing item within a [Block].
class BlockPrepareItemEditResult<ID extends Comparable,
ITEM extends Identifiable<ID>, ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID,
        ITEM,
        ITEM_DETAIL,
        BlockItemEditPrecheck> {
  /// The item originally targeted for editing when the operation started.
  final ITEM? targetItem;

  /// The active current item of the block after execution completes.
  /// May differ from [targetItem] (or be null) if the target was evicted remotely.
  final ITEM? currentItem;

  /// Indicates whether the form model reached a loaded-fresh state ready for editing.
  final bool formReady;

  BlockPrepareItemEditResult({
    super.precheck,
    super.errorInfo,
    required this.targetItem,
    required this.currentItem,
    required this.formReady,
  });

  /// Indicates whether the targeted item was evicted remotely during refresh.
  bool get targetItemEvicted =>
      precheck == null &&
          errorInfo == null &&
          targetItem != null &&
          currentItem?.id != targetItem!.id;

  @override
  bool get successForFirst {
    if (precheck != null || errorInfo != null) {
      return false;
    }
    if (targetItem == null || currentItem == null) {
      return false;
    }
    if (targetItem!.id != currentItem!.id) {
      return false;
    }
    return formReady;
  }
}
