import '../core.dart';

class BlockDataStateUtils {
  /// Calculates the next deferred [BlockDataState] when this Block is currently hidden
  /// or off-screen, eliminating the overhead of immediate network execution.
  ///
  /// ### Transition Scenarios:
  /// 1. **Parent Context Shift (`parentItemChanged` / `!hasParentItem`)**:
  ///    - If this block is a child block and the parent item is null, transitions directly to `None`[cite: 8].
  ///    - If the parent item identity mutated, previous data cache is evicted, resetting the state to `Pending.initial`[cite: 8].
  /// 2. **Filter Criteria Shift (`filterCriteriaChanged`)**:
  ///    - If data is already in RAM (`LoadedFresh` or `LoadedStale`), marks it as `LoadedStale(filterChanged)`
  ///      while safely carrying over any prior failure history via [retainedFailureReason][cite: 8].
  ///    - If data is cold (`Pending`), transitions to `Pending.filterChanged`[cite: 8].
  /// 3. **Incoming Domain Mutation Events (`hasIncomingEvent`)**:
  ///    - When loaded in RAM, transitions to `LoadedStale(event)` preserving previous failures[cite: 8].
  static BlockDataState calculateNewLazyDataState({
    required BlockDataState currentBlockDataState,
    required bool hasParentItem,
    required bool isRootBlock,
    required bool parentItemChanged,
    required bool filterCriteriaChanged,
    bool hasIncomingEvent = false,
  }) {
    // 1. Child blocks require an active parent item selection to remain viable
    if (!isRootBlock && !hasParentItem) {
      return const BlockDataStateNone();
    }

    // 2. If the parent item identity changed, all existing child dataset cache is evicted
    if (!isRootBlock && parentItemChanged) {
      return const BlockDataStatePending.initial();
    }

    switch (currentBlockDataState) {
      // Uninitialized blocks stay in Pending once parent identity is established
      case BlockDataStateNone():
        return const BlockDataStatePending.initial();

      // Cold baseline states
      case BlockDataStatePending(:final reason):
        if (filterCriteriaChanged) {
          final BlockPendingReasonFailed? priorFailure = switch (reason) {
            BlockPendingReasonFailed failure => failure,
            BlockPendingReasonFilterChanged(:final retainedFailureReason) =>
              retainedFailureReason,
            _ => null,
          };
          return BlockDataStatePending.filterChanged(
            retainedFailureReason: priorFailure,
          );
        }
        return currentBlockDataState;

      // Active and clean dataset in RAM
      case BlockDataStateLoadedFresh(:final transientErrorInfo):
        if (filterCriteriaChanged) {
          return BlockDataStateLoadedStale.filterChanged();
        }
        if (hasIncomingEvent) {
          return BlockDataStateLoadedStale.event();
        }
        return currentBlockDataState;

      // Dataset in RAM that is already marked stale
      case BlockDataStateLoadedStale(:final reason):
        // Extract existing failure reason across multiple hops
        final BlockLoadedStateStaleReasonFailed? priorFailure =
            switch (reason) {
          BlockLoadedStateStaleReasonFailed failure => failure,
          BlockLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
            retainedFailureReason,
          BlockLoadedStateStaleReasonFilterChanged(
            :final retainedFailureReason
          ) =>
            retainedFailureReason,
        };

        if (filterCriteriaChanged) {
          return BlockDataStateLoadedStale.filterChanged(
            retainedFailureReason: priorFailure,
          );
        }

        if (hasIncomingEvent) {
          return BlockDataStateLoadedStale.event(
            retainedFailureReason: priorFailure,
          );
        }

        return currentBlockDataState;
    }
  }
}
