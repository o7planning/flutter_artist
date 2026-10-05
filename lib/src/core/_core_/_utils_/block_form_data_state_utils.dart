import '../core.dart';

class BlockFormDataStateUtils {
  /// Calculates the next deferred [FormDataState] when the associated Form is currently hidden
  /// or off-screen, eliminating the overhead of immediate network refetches.
  ///
  /// ### Context & Motivation:
  /// When a bound item updates or refreshes in the parent Block, loading the hidden Form immediately
  /// wastes bandwidth and creates unnecessary waterfall requests. Instead, this utility computes
  /// a transition state based on:
  /// 1. **Target Item Identity**: Whether the active item identity actually changed.
  /// 2. **Data Staleness & Error Preservation**: If the current item is merely refreshed in-place,
  ///    loaded data in RAM is marked stale (`hostDataRefreshed`), while any historical network failure
  ///    is safely carried over via [retainedFailureReason].
  ///
  /// This ensures that whenever the user navigates back to the Form later, the framework can decide
  /// whether to perform a background revalidation or display an actionable retry interface.
  static FormDataState calculateNewLazyDataState({
    required FormDataState currentFormDataState,
    required bool hasCurrentItem,
    required bool currentItemChanged,
  }) {
    // 1. Without an active item selected in the parent Block, the Form remains dormant.
    if (!hasCurrentItem) {
      return const FormDataStateNone();
    }

    switch (currentFormDataState) {
      // 2. Uninitialized states transition directly to Pending.
      case FormDataStateNone():
        return const FormDataStatePending.initial();

      // 3. Already pending states:
      // If identity changed, reset to initial pending; otherwise, retain current pending state.
      case FormDataStatePending():
        if (currentItemChanged) {
          return const FormDataStatePending.initial();
        }
        return currentFormDataState;

      // 4. Fatal bootstrapping failure:
      // If the target item changed, discard previous fatal errors and restart bootstrapping via Pending.hostDataRefreshed.
      // Otherwise, retain the fatal lock until the user or system triggers an explicit reload.
      case FormDataStateFatalError():
        if (currentItemChanged) {
          return FormDataStatePending.hostDataRefreshed();
        }
        return currentFormDataState;

      // 5. Clean data in RAM (LoadedFresh):
      // If identity changed, enter Pending (carrying optional prior failure context if applicable).
      // If refreshed in-place, transition to Stale with reason hostDataRefreshed.
      case FormDataStateLoadedFresh():
        if (currentItemChanged) {
          return FormDataStatePending.hostDataRefreshed();
        }
        return FormDataStateLoadedStale.hostDataRefreshed();

      // 6. Outdated data in RAM (LoadedStale):
      // If identity changed, cache is evicted to Pending.hostDataRefreshed.
      // If refreshed in-place, mark reason as hostDataRefreshed while preserving any prior failure history.
      case FormDataStateLoadedStale(:final reason):
        if (currentItemChanged) {
          // Extract prior failure before evicting to pending if needed, or clear.
          final FormLoadedStateStaleReasonFailed? priorFailure =
              switch (reason) {
            FormLoadedStateStaleReasonFailed failure => failure,
            FormLoadedStateStaleReasonHostDataRefreshed(
              :final retainedFailureReason
            ) =>
              retainedFailureReason,
            FormLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
              retainedFailureReason,
          };
          return FormDataStatePending.hostDataRefreshed(
            retainedFailureReason: priorFailure != null
                ? FormPendingReasonFailed(errorInfo: priorFailure.errorInfo)
                : null,
          );
        }

        // Extract and propagate the most recent failure reason across state hops in-place
        final FormLoadedStateStaleReasonFailed? priorFailure = switch (reason) {
          FormLoadedStateStaleReasonFailed failure => failure,
          FormLoadedStateStaleReasonHostDataRefreshed(
            :final retainedFailureReason
          ) =>
            retainedFailureReason,
          FormLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
            retainedFailureReason,
        };

        return FormDataStateLoadedStale.hostDataRefreshed(
          retainedFailureReason: priorFailure,
        );
    }
  }
}
