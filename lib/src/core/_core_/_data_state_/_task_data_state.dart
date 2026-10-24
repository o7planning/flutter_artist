part of '../core.dart';

/// Root sealed state container for Task lifecycle readiness and submission outcome.
@immutable
sealed class TaskDataState implements DataState {
  const TaskDataState();

  String get name;

  bool get isPending => this is TaskDataStatePending;

  bool get isLoaded => this is TaskDataStateLoaded;

  bool get isFresh => this is TaskDataStateLoadedFresh;

  bool get isStale => this is TaskDataStateLoadedStale;

  bool get isSubmissionAttempted => this is TaskDataStateSubmissionAttempted;

  bool get isSubmissionAttemptedSuccess =>
      this is TaskDataStateSubmissionAttemptedSuccess;

  bool get isSubmissionAttemptedFailed =>
      this is TaskDataStateSubmissionAttemptedFailed;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  TaskErrorInfo? get errorInfo;

  bool get hasError => errorInfo != null;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

// =============================================================================
// 1. PENDING STATE HIERARCHY
// =============================================================================

/// Task is preparing its initial context (fetching INIT_DATA) or failed during setup.
final class TaskDataStatePending extends TaskDataState {
  final TaskPendingReason reason;

  const TaskDataStatePending({
    this.reason = const TaskPendingReasonInitial(),
  });

  const TaskDataStatePending.initial()
      : reason = const TaskPendingReasonInitial();

  TaskDataStatePending.failed({
    required TaskErrorInfo errorInfo,
  }) : reason = TaskPendingReasonFailed(errorInfo: errorInfo);

  @override
  String get name => "pending";

  @override
  TaskErrorInfo? get errorInfo => reason.errorInfo;

  bool get hasFailure => reason.isFailed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'TaskDataState.pending(reason: $reason)';
}

/// Sealed rationale hierarchy behind a [TaskDataStatePending].
sealed class TaskPendingReason {
  const TaskPendingReason();

  String toBriefInfo();

  bool get isInitial => this is TaskPendingReasonInitial;

  bool get isFailed => this is TaskPendingReasonFailed;

  TaskErrorInfo? get errorInfo => switch (this) {
        TaskPendingReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Initial cold state waiting to fetch INIT_DATA.
final class TaskPendingReasonInitial extends TaskPendingReason {
  const TaskPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'TaskPendingReason.initial';
}

/// Failed while loading INIT_DATA.
final class TaskPendingReasonFailed extends TaskPendingReason {
  @override
  final TaskErrorInfo errorInfo;

  const TaskPendingReasonFailed({required this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPendingReasonFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "failed(err)";

  @override
  String toString() => 'TaskPendingReason.failed(errorInfo: $errorInfo)';
}

// =============================================================================
// 2. LOADED STATE HIERARCHY
// =============================================================================

/// Base sealed class when INIT_DATA is available in RAM and form is interactive.
sealed class TaskDataStateLoaded extends TaskDataState {
  const TaskDataStateLoaded();

  @override
  TaskErrorInfo? get errorInfo => null;
}

/// INIT_DATA is fresh and ready for user form input.
final class TaskDataStateLoadedFresh extends TaskDataStateLoaded {
  const TaskDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "loadedFresh()";

  @override
  String toString() => 'TaskDataState.loadedFresh()';
}

/// INIT_DATA is retained but stale (e.g. background external invalidation).
final class TaskDataStateLoadedStale extends TaskDataStateLoaded {
  final TaskErrorInfo? staleErrorInfo;

  const TaskDataStateLoadedStale({this.staleErrorInfo});

  @override
  String get name => "loaded + stale";

  @override
  TaskErrorInfo? get errorInfo => staleErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          staleErrorInfo == other.staleErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, staleErrorInfo);

  @override
  String toBriefInfo() => "loadedStale(${staleErrorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'TaskDataState.loadedStale(errorInfo: $staleErrorInfo)';
}

// =============================================================================
// 3. SUBMISSION ATTEMPTED STATE HIERARCHY
// =============================================================================

/// Base sealed class when a submission attempt has been executed.
sealed class TaskDataStateSubmissionAttempted extends TaskDataState {
  const TaskDataStateSubmissionAttempted();
}

/// Task completed execution successfully, yielding transaction results.
final class TaskDataStateSubmissionAttemptedSuccess
    extends TaskDataStateSubmissionAttempted {
  const TaskDataStateSubmissionAttemptedSuccess();

  @override
  String get name => "submissionAttempted + success";

  @override
  TaskErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDataStateSubmissionAttemptedSuccess;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "submissionSuccess()";

  @override
  String toString() => 'TaskDataState.submissionAttemptedSuccess()';
}

/// Task execution/submission failed on server; inputs remain available for user correction.
final class TaskDataStateSubmissionAttemptedFailed
    extends TaskDataStateSubmissionAttempted {
  final TaskErrorInfo submissionErrorInfo;

  const TaskDataStateSubmissionAttemptedFailed({
    required this.submissionErrorInfo,
  });

  @override
  String get name => "submissionAttempted + failed";

  @override
  TaskErrorInfo? get errorInfo => submissionErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDataStateSubmissionAttemptedFailed &&
          runtimeType == other.runtimeType &&
          submissionErrorInfo == other.submissionErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, submissionErrorInfo);

  @override
  String toBriefInfo() => "submissionFailed(err)";

  @override
  String toString() =>
      'TaskDataState.submissionAttemptedFailed(errorInfo: $submissionErrorInfo)';
}
