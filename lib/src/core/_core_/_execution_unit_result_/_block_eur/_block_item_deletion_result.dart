part of '../../core.dart';

/// Execution result representing the outcome of deleting a single item within a [Block],
/// backed by [BlockOperationStep] journaling.
class BlockItemDeletionResult<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends BlockExecutionUnitResult<
    ID, //
    ITEM,
    ITEM_DETAIL,
    BlockItemDeletionPrecheck> {
  final ITEM? candidateItem;

  BlockItemDeletionResult({
    required this.candidateItem,
    super.precheck,
    super.errorInfo,
  });

  /// Evaluates primary success: true if precheck passed, errorInfo is null,
  /// and the target item was successfully evicted from storage.
  @override
  bool get successForFirst {
    if (precheck != null || errorInfo != null) {
      return false;
    }
    return deletedItem != null && failedOperation == null;
  }

  // ===========================================================================
  // JOURNAL-DERIVED CONVENIENCE ACCESSORS
  // ===========================================================================

  /// The item that was successfully evicted during this deletion sequence.
  ITEM? get deletedItem => evictedItems.firstOrNull;

  /// Failed operation encountered during item deletion, if any.
  ItemOperationFailedStep<ID, ITEM>? get failedOperation =>
      journalSteps.whereType<ItemOperationFailedStep<ID, ITEM>>().firstOrNull;

  /// The item that failed to be deleted, if any.
  ITEM? get failedItem => failedOperation?.item;
}
