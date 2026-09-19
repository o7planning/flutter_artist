import '../core.dart';

class ScalarDataStateUtils {
  /// Calculates the next deferred [ScalarDataState] when this Scalar is currently hidden
  /// or off-screen, eliminating redundant metric recalculations or network fetches.
  ///
  /// ### Transition Scenarios:
  /// 1. **Parent Context Shift (`parentValueChanged` / `!hasParentValue`)**:
  ///    - If this scalar depends on a parent scalar whose value is absent, transitions to `None`[cite: 9].
  ///    - If the parent value shifted identity, cached scalar value is evicted to `Pending.initial`[cite: 9].
  /// 2. **Filter Criteria Shift (`filterCriteriaChanged`)**:
  ///    - Transitions loaded scalar metrics to `LoadedStale(filterChanged)` preserving historical failures[cite: 9].
  ///    - Invalidate pending states to `Pending.filterChanged`[cite: 9].
  /// 3. **Incoming Domain Events (`hasIncomingEvent`)**:
  ///    - Marks active in-memory values as `LoadedStale(event)` without discarding previous error payloads[cite: 9].
  static ScalarDataState calculateNewLazyDataState({
    required ScalarDataState currentScalarDataState,
    required bool hasParentValue,
    required bool isRootScalar,
    required bool parentValueChanged,
    required bool filterCriteriaChanged,
    bool hasIncomingEvent = false,
  }) {
    // 1. Dependent child scalars require an active parent value context
    if (!isRootScalar && !hasParentValue) {
      return const ScalarDataStateNone();
    }

    // 2. Upstream parent value identity mutation evicts local scalar cache
    if (!isRootScalar && parentValueChanged) {
      return const ScalarDataStatePending.initial();
    }

    switch (currentScalarDataState) {
    // Uninitialized scalars transition to Pending when ancestor constraints are satisfied
      case ScalarDataStateNone():
        return const ScalarDataStatePending.initial();

    // Cold baseline states
      case ScalarDataStatePending(:final reason):
        if (filterCriteriaChanged) {
          final ScalarPendingReasonFailed? priorFailure = switch (reason) {
            ScalarPendingReasonFailed failure => failure,
            ScalarPendingReasonFilterChanged(:final retainedFailureReason) =>
            retainedFailureReason,
            _ => null,
          };
          return ScalarDataStatePending.filterChanged(
            retainedFailureReason: priorFailure,
          );
        }
        return currentScalarDataState;

    // Active and valid scalar metric in RAM
      case ScalarDataStateLoadedFresh(:final transientErrorInfo):
        if (filterCriteriaChanged) {
          return ScalarDataStateLoadedStale.filterChanged();
        }
        if (hasIncomingEvent) {
          return ScalarDataStateLoadedStale.event();
        }
        return currentScalarDataState;

    // Scalar metric in RAM that is already outdated
      case ScalarDataStateLoadedStale(:final reason):
      // Extract and propagate earlier query failure across state transformations
        final ScalarLoadedStateStaleReasonFailed? priorFailure =
        switch (reason) {
          ScalarLoadedStateStaleReasonFailed failure => failure,
          ScalarLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
          retainedFailureReason,
          ScalarLoadedStateStaleReasonFilterChanged(
              :final retainedFailureReason
          ) =>
          retainedFailureReason,
        };

        if (filterCriteriaChanged) {
          return ScalarDataStateLoadedStale.filterChanged(
            retainedFailureReason: priorFailure,
          );
        }

        if (hasIncomingEvent) {
          return ScalarDataStateLoadedStale.event(
            retainedFailureReason: priorFailure,
          );
        }

        return currentScalarDataState;
    }
  }
}
