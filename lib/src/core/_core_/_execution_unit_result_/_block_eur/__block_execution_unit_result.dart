part of '../../core.dart';

/// Base execution unit result class holding domain-level mutation journals
/// specifically tailored for [Block] operations and item lifecycle transitions.
abstract class BlockExecutionUnitResult<
ID extends Comparable,
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>,
PRECHECK> extends ExecutionUnitResult<PRECHECK> {
  /// Chronological audit journal recording atomic mutation steps executed during this intent.
  final List<BlockOperationStep<ID, ITEM>> _journalSteps = [];

  /// Unmodifiable view of all recorded lifecycle operation steps.
  List<BlockOperationStep<ID, ITEM>> get journalSteps =>
      List.unmodifiable(_journalSteps);

  BlockExecutionUnitResult({
    super.precheck,
    super.errorInfo,
  });

  BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic>? _nextResult;

  BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic>? get nextResult =>
      _nextResult;

  // TODO: To private.
  void linkNextResult(
      BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic> result) {
    _nextResult = result;
  }

  ITEM? get finalCurrentItem {
    if (_nextResult is BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>) {
      return (_nextResult as BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>)
          .currentItem;
    }
    if (this is BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>) {
      return (this as BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>)
          .currentItem;
    }
    return null;
  }

  // ===========================================================================

  /// Appends an atomic operation step to the internal journal.
  void recordStep(BlockOperationStep<ID, ITEM> step) {
    _journalSteps.add(step);
  }

  // ===========================================================================
  // CONVENIENCE STEP RECORDING METHODS (TYPED FOR BLOCK / ITEM)
  // ===========================================================================

  /// Records an eviction event where an item is removed from memory or remote storage.
  void recordEviction({
    required ITEM item,
    required ItemEvictionReason reason,
    ErrorInfo? errorInfo,
  }) {
    recordStep(
      ItemEvictionStep<ID, ITEM>(
        item: item,
        reason: reason,
        errorInfo: errorInfo,
      ),
    );
  }

  /// Records an active selection or current item transition event.
  void recordCurrentTransition({
    required ITEM? previousItem,
    required ITEM? candidateItem,
    required ITEM? finalItem,
    required CurrentItemTransitionTrigger trigger,
  }) {
    recordStep(
      CurrentItemTransitionStep<ID, ITEM>(
        previousItem: previousItem,
        candidateItem: candidateItem,
        finalItem: finalItem,
        trigger: trigger,
      ),
    );
  }

  /// Records a localized operational failure that affected a specific item
  /// without aborting the entire execution unit queue.
  void recordItemOperationFailure({
    required ITEM? item,
    required String operation,
    required ErrorInfo errorInfo,
  }) {
    recordStep(
      ItemOperationFailedStep<ID, ITEM>(
        item: item,
        operation: operation,
        errorInfo: errorInfo,
      ),
    );
  }

  /// Records a cascaded state invalidation or reset applied to downstream child blocks.
  void recordCascadedEviction({
    required String childBlockName,
    required BlockDataState targetState,
  }) {
    recordStep(
      CascadedEvictionStep<ID, ITEM>(
        childBlockName: childBlockName,
        targetState: targetState,
      ),
    );
  }

  /// Records the batch mutation footprint and resolved viewport sync policy
  /// for bulk backend operations.
  void recordBackendOperationFootprint({
    required String actionName,
    required List<ID> effectedItemIds,
    required BlockViewportSyncStrategy resolvedSyncStrategy,
  }) {
    recordStep(
      BackendOperationFootprintStep<ID, ITEM>(
        actionName: actionName,
        effectedItemIds: effectedItemIds,
        resolvedSyncStrategy: resolvedSyncStrategy,
      ),
    );
  }

  // ===========================================================================
  // HIGH-LEVEL AUDIT QUERY HELPERS
  // ===========================================================================

  /// Resolves the list of all entities evicted or deleted during this execution session.
  List<ITEM> get evictedItems =>
      journalSteps
          .whereType<ItemEvictionStep<ID, ITEM>>()
          .map((step) => step.item)
          .toList();

  /// Retrieves the latest current item transition recorded in this execution session, if any.
  CurrentItemTransitionStep<ID, ITEM>? get lastCurrentTransition =>
      journalSteps
          .whereType<CurrentItemTransitionStep<ID, ITEM>>()
          .lastOrNull;

  // ===========================================================================
  // DEBUG LOGGING UTILITY
  // ===========================================================================

  /// Prints the full chronological sequence of operations captured in this result.
  void printDebug({String? tag}) {
    final buffer = StringBuffer();
    final headerTag = tag != null ? '[$tag] ' : '';
    buffer.writeln(
        '==================== ${headerTag}EXECUTION JOURNAL STEPS ====================');
    buffer.writeln('Result Type : $runtimeType');
    buffer.writeln('Precheck    : $precheck');
    buffer.writeln('Error Info  : ${errorInfo?.errorMessage ?? "None"}');
    buffer.writeln('Total Steps : ${_journalSteps.length}');
    buffer.writeln(
        '----------------------------------------------------------------------');

    if (_journalSteps.isEmpty) {
      buffer.writeln('  (No lifecycle mutation steps recorded)');
    } else {
      for (int i = 0; i < _journalSteps.length; i++) {
        final step = _journalSteps[i];
        final prefix = '  #${(i + 1).toString().padLeft(2, '0')}: ';
        buffer.writeln('$prefix${step.toString()}');
      }
    }
    buffer.writeln(
        '======================================================================');
    print(buffer.toString());
  }
}
