part of '../../core.dart';

/// Execution unit result representing the outcome of refreshing the active
/// current item within a [Block].
class BlockRefreshCurrentItemResult<ID extends Comparable,
ITEM extends Identifiable<ID>, ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID,
        ITEM,
        ITEM_DETAIL,
        BlockRefreshCurrentItemPrecheck> {
  /// The original current item targeted for refresh when the operation started.
  final ITEM? targetItem;

  /// The item that was actively assigned before this execution began.
  final ITEM? oldCurrentItem;

  /// The item actively assigned as current upon completion.
  /// May differ from [targetItem] (or be null) if the target was evicted remotely.
  final ITEM? _currentItem;

  /// Retrieves the item currently assigned as active after execution completes.
  ITEM? get currentItem => _currentItem;

  BlockRefreshCurrentItemResult({
    required super.precheck,
    super.errorInfo,
    required this.targetItem,
    required this.oldCurrentItem,
    required ITEM? currentItem,
  }) : _currentItem = currentItem;

  /// Creates a [BlockRefreshCurrentItemResult] mirroring the execution outcome
  /// and audit journal of an internal [BlockSetCurrentItemResult].
  factory BlockRefreshCurrentItemResult._fromSetCurrentItemResult(
      BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL> source,) {
    final result = BlockRefreshCurrentItemResult<ID, ITEM, ITEM_DETAIL>(
      precheck: null,
      errorInfo: source.errorInfo,
      targetItem: source.initialCandidateItem,
      oldCurrentItem: source.oldCurrentItem,
      currentItem: source.currentItem,
    );
    for (final step in source.journalSteps) {
      result.recordStep(step);
    }
    if (source.nextResult != null) {
      result.linkNextResult(source.nextResult!);
    }
    return result;
  }

  /// Indicates whether the targeted current item was refreshed and remains active
  /// without unhandled errors.
  @override
  bool get successForFirst {
    if (precheck != null || errorInfo != null) {
      return false;
    }
    if (targetItem == null || _currentItem == null) {
      return false;
    }
    return targetItem!.id == _currentItem!.id;
  }

  @override
  bool get successForAll => successForFirst;

  /// Determines whether the active current item changed (e.g., due to remote eviction fallback).
  bool get hasCurrentItemChanged => oldCurrentItem?.id != _currentItem?.id;
}
