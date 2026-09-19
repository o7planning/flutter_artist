import '../core.dart';

class FormDataStateUtils {
  /// Calculates the next deferred [FormDataState] when the associated Form is currently hidden
  /// or off-screen, eliminating the overhead of immediate network refetches.
  ///
  /// ### Context & Motivation:
  /// When a bound item updates or refreshes in the parent Block, loading the hidden Form immediately
  /// wastes bandwidth and creates unnecessary waterfall requests. Instead, this utility computes
  /// a transition state based on:
  /// 1. **Target Item Identity**: Whether the active item identity actually changed.
  /// 2. **Data Staleness & Error Preservation**: If the current item is merely refreshed in-place,
  ///    loaded data in RAM is marked stale (`itemRefreshed`), while any historical network failure
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
    // 2. Uninitialized or cold-bootstrapping states transition directly to Pending.
      case FormDataStateNone():
      case FormDataStatePending():
        return const FormDataStatePending();

    // 3. Fatal bootstrapping failure:
    // If the target item changed, discard previous fatal errors and restart bootstrapping.
    // Otherwise, retain the fatal lock until the user or system triggers an explicit reload.
      case FormDataStateFatalError():
        if (currentItemChanged) {
          return const FormDataStatePending();
        }
        return currentFormDataState;

    // 4. Clean data in RAM:
    // If identity changed, flush cache and enter Pending.
    // If refreshed in-place, transition to Stale without any historical failure payload.
      case FormDataStateLoadedFresh():
        if (currentItemChanged) {
          return const FormDataStatePending();
        }
        return const FormDataStateLoadedStale(
          reason: FormLoadedStateStaleReasonItemRefreshed(),
        );

    // 5. Outdated data in RAM:
    // If identity changed, cache is evicted to Pending.
    // If refreshed in-place, mark reason as itemRefreshed while preserving any prior failure history.
      case FormDataStateLoadedStale(:final reason):
        if (currentItemChanged) {
          return const FormDataStatePending();
        }

        // Extract and propagate the most recent failure reason across state hops
        final FormLoadedStateStaleReasonFailed? priorFailure = switch (reason) {
          FormLoadedStateStaleReasonFailed failure => failure,
          FormLoadedStateStaleReasonItemRefreshed(
              :final retainedFailureReason
          ) =>
          retainedFailureReason,
          FormLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
          retainedFailureReason,
        };

        return FormDataStateLoadedStale(
          reason: FormLoadedStateStaleReasonItemRefreshed(
            retainedFailureReason: priorFailure,
          ),
        );
    }
  }
}
