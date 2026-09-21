part of '../../core.dart';

/// Execution result for batch item deletion intents, powered by [BlockOperationStep] journaling.
class BlockItemsDeletionResult<ID extends Comparable,
        ITEM extends Identifiable<ID>, ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemsDeletionPrecheck> {
  final List<ITEM> candidateItems;

  BlockItemsDeletionResult({
    required this.candidateItems,
    super.precheck,
    super.errorInfo,
  });

  /// Evaluates primary success: true if precheck passed and no individual item failures occurred.
  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return failedOperations.isEmpty;
  }

  // ===========================================================================
  // JOURNAL-DERIVED CONVENIENCE ACCESSORS
  // ===========================================================================

  /// Entities that were successfully evicted during this batch deletion sequence.
  List<ITEM> get deletedItems => evictedItems;

  /// Failed operations encountered during item deletions.
  List<ItemOperationFailedStep<ID, ITEM>> get failedOperations =>
      journalSteps.whereType<ItemOperationFailedStep<ID, ITEM>>().toList();

  /// Indicates whether all targeted items were successfully deleted.
  bool get isAllDeleted =>
      deletedItems.length == candidateItems.length && failedOperations.isEmpty;
}
