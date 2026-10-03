part of '../core.dart';

/// Root sealed state container for individual Stage lifecycle within a Prozess.
@immutable
sealed class StageDataState  implements DataState{
  const StageDataState();

  String get name;

  bool get isNone => this is StageDataStateNone;

  bool get isPending => this is StageDataStatePending;

  bool get isLoaded => this is StageDataStateLoaded;

  bool get isFresh => this is StageDataStateLoadedFresh;

  bool get isStale => this is StageDataStateLoadedStale;

  bool get isSubmissionAttempted => this is StageDataStateSubmissionAttempted;

  bool get isSubmissionAttemptedSuccess =>
      this is StageDataStateSubmissionAttemptedSuccess;

  bool get isSubmissionAttemptedFailed =>
      this is StageDataStateSubmissionAttemptedFailed;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  StageErrorInfo? get errorInfo;

  bool get hasError => errorInfo != null;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

// =============================================================================
// 1. NONE STATE (Stage not yet reached in workprozess)
// =============================================================================

/// Stage has not been activated or reached in the active Prozess.
final class StageDataStateNone extends StageDataState {
  const StageDataStateNone();

  @override
  String get name => "none";

  @override
  StageErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'StageDataState.none()';
}

// =============================================================================
// 2. PENDING STATE HIERARCHY
// =============================================================================

/// Stage is focused, currently resolving/fetching its INIT_DATA from sharedContext.
final class StageDataStatePending extends StageDataState {
  final StagePendingReason reason;

  const StageDataStatePending({
    this.reason = const StagePendingReasonInitial(),
  });

  const StageDataStatePending.initial()
      : reason = const StagePendingReasonInitial();

  StageDataStatePending.failed({
    required StageErrorInfo errorInfo,
  }) : reason = StagePendingReasonFailed(errorInfo: errorInfo);

  @override
  String get name => "pending";

  @override
  StageErrorInfo? get errorInfo => reason.errorInfo;

  bool get hasFailure => reason.isFailed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StageDataStatePending &&
              runtimeType == other.runtimeType &&
              reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'StageDataState.pending(reason: $reason)';
}

/// Sealed rationale hierarchy behind a [StageDataStatePending].
sealed class StagePendingReason {
  const StagePendingReason();

  String toBriefInfo();

  bool get isInitial => this is StagePendingReasonInitial;

  bool get isFailed => this is StagePendingReasonFailed;

  StageErrorInfo? get errorInfo =>
      switch (this) {
        StagePendingReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

final class StagePendingReasonInitial extends StagePendingReason {
  const StagePendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StagePendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'StagePendingReason.initial';
}

final class StagePendingReasonFailed extends StagePendingReason {
  @override
  final StageErrorInfo errorInfo;

  const StagePendingReasonFailed({required this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StagePendingReasonFailed &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "failed(err)";

  @override
  String toString() => 'StagePendingReason.failed(errorInfo: $errorInfo)';
}

// =============================================================================
// 3. LOADED STATE HIERARCHY
// =============================================================================

/// Base sealed class when Stage INIT_DATA is resolved and the step is interactive.
sealed class StageDataStateLoaded extends StageDataState {
  const StageDataStateLoaded();

  @override
  StageErrorInfo? get errorInfo => null;
}

/// Stage INIT_DATA is synchronized with current Prozess state.
final class StageDataStateLoadedFresh extends StageDataStateLoaded {
  const StageDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "loadedFresh()";

  @override
  String toString() => 'StageDataState.loadedFresh()';
}

/// Predecessor stage mutations occurred, making current step data stale.
final class StageDataStateLoadedStale extends StageDataStateLoaded {
  final StageErrorInfo? staleErrorInfo;

  const StageDataStateLoadedStale({this.staleErrorInfo});

  @override
  String get name => "loaded + stale";

  @override
  StageErrorInfo? get errorInfo => staleErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StageDataStateLoadedStale &&
              runtimeType == other.runtimeType &&
              staleErrorInfo == other.staleErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, staleErrorInfo);

  @override
  String toBriefInfo() => "loadedStale(${staleErrorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'StageDataState.loadedStale(errorInfo: $staleErrorInfo)';
}

// =============================================================================
// 4. SUBMISSION ATTEMPTED STATE HIERARCHY
// =============================================================================

/// Base sealed class when step submission has been executed.
sealed class StageDataStateSubmissionAttempted extends StageDataState {
  const StageDataStateSubmissionAttempted();
}

/// Step submission confirmed, advancing prozess to next stage.
final class StageDataStateSubmissionAttemptedSuccess
    extends StageDataStateSubmissionAttempted {
  const StageDataStateSubmissionAttemptedSuccess();

  @override
  String get name => "submissionAttempted + success";

  @override
  StageErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StageDataStateSubmissionAttemptedSuccess;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "submissionSuccess()";

  @override
  String toString() => 'StageDataState.submissionAttemptedSuccess()';
}

/// Step submission failed (validation/backend); stage remains active to fix inputs.
final class StageDataStateSubmissionAttemptedFailed
    extends StageDataStateSubmissionAttempted {
  final StageErrorInfo submissionErrorInfo;

  const StageDataStateSubmissionAttemptedFailed({
    required this.submissionErrorInfo,
  });

  @override
  String get name => "submissionAttempted + failed";

  @override
  StageErrorInfo? get errorInfo => submissionErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StageDataStateSubmissionAttemptedFailed &&
              runtimeType == other.runtimeType &&
              submissionErrorInfo == other.submissionErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, submissionErrorInfo);

  @override
  String toBriefInfo() => "submissionFailed(err)";

  @override
  String toString() =>
      'StageDataState.submissionAttemptedFailed(errorInfo: $submissionErrorInfo)';
}
