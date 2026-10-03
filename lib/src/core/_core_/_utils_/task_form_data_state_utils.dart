import 'package:flutter_artist_core/flutter_artist_core.dart';
import '../core.dart';

class TaskFormDataStateUtils {
  /// Calculates the next [FormDataState] for a Task Form when the owning [Task]
  /// experiences a state shift or an initialization reload.
  static FormDataState calculateNewLazyDataState({
    required FormDataState currentFormDataState,
    required TaskDataState taskDataState,
    required bool hasInitData,
  }) {
    // 1. If the task has no initialization data, the form remains dormant (None).
    if (!hasInitData) {
      return const FormDataStateNone();
    }

    // 2. Map transition logic based on the owning Task's core data state
    switch (taskDataState) {
      // Case 1: Task is in Pending state (e.g., cold start or reloading initData)
      case TaskDataStatePending(:final reason):
        // Extract prior failure history from current form state to preserve error tracking.
        // Explicitly cast the switch expression result to avoid 'Object?' type mismatch.
        final FormPendingReasonFailed? priorFailure =
            switch (currentFormDataState) {
          FormDataStateFatalError(:final errorInfo) =>
            FormPendingReasonFailed(errorInfo: errorInfo),
          FormDataStateLoadedStale(:final reason) => switch (reason) {
              FormLoadedStateStaleReasonFailed(:final errorInfo) =>
                FormPendingReasonFailed(errorInfo: errorInfo),
              FormLoadedStateStaleReasonHostDataRefreshed(
                :final retainedFailureReason
              ) =>
                retainedFailureReason,
              FormLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
                retainedFailureReason,
            },
          FormDataStatePending(:final reason) => reason.underlyingFailureReason,
          _ => null,
        } as FormPendingReasonFailed?;

        if (reason.isFailed || priorFailure != null) {
          return FormDataStatePending.hostDataRefreshed(
            retainedFailureReason: priorFailure ??
                (reason.errorInfo != null
                    ? FormPendingReasonFailed(
                        errorInfo: reason.errorInfo!.toErrorInfo(),
                      )
                    : null),
          );
        }
        return const FormDataStatePending.initial();

      // Case 2: Task successfully loaded fresh INIT_DATA
      case TaskDataStateLoadedFresh():
        // IMPORTANT NOTE:
        // When the parent Task successfully reloads fresh init data from a stale/error state,
        // we must NOT automatically force the Form's state to LoadedFresh.
        // If the form is already initialized (not None), we transition it to LoadedStale (hostDataRefreshed)
        // instead. This ensures the Form is prompted to execute its own data loading/refresh lifecycle
        // independently, rather than bypassing its synchronization cycle with the new task init data.
        if (currentFormDataState.isNone) {
          return const FormDataStateLoadedFresh();
        }
        return FormDataStateLoadedStale.hostDataRefreshed();

      // Case 3: Task reload failed and became Stale
      case TaskDataStateLoadedStale(:final staleErrorInfo):
        final ErrorInfo? errorInfo = staleErrorInfo?.toErrorInfo();
        if (errorInfo != null) {
          return FormDataStateLoadedStale.failed(errorInfo: errorInfo);
        }
        return FormDataStateLoadedStale.hostDataRefreshed();

      // Case 4: Task submission attempted success
      case TaskDataStateSubmissionAttemptedSuccess():
        return currentFormDataState;

      // Case 5: Task submission attempted failed
      case TaskDataStateSubmissionAttemptedFailed(:final submissionErrorInfo):
        return FormDataStateLoadedStale.failed(
          errorInfo: submissionErrorInfo.toErrorInfo(),
        );
    }
  }
}
