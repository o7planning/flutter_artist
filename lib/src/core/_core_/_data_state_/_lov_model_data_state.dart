part of '../core.dart';

// =============================================================================
// LOV DATA STATE HIERARCHY
// =============================================================================

/// Root sealed state container for [LovModel] data lifecycle.
@immutable
sealed class LovDataState implements DataState {
  const LovDataState();

  String get name;

  bool get isPending => this is LovDataStatePending;

  bool get isLoaded => this is LovDataStateLoaded;

  bool get isLoadedFresh => this is LovDataStateLoadedFresh;

  bool get isLoadedStale => this is LovDataStateLoadedStale;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  LovModelErrorInfo? get errorInfo;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Cold baseline loading state (no prior active dataset in RAM, or evicted).
final class LovDataStatePending extends LovDataState {
  final LovPendingReason reason;

  const LovDataStatePending({
    this.reason = const LovPendingReasonInitial(),
  });

  /// Factory constructor for standard cold initial loading.
  const LovDataStatePending.initial()
      : reason = const LovPendingReasonInitial();

  /// Factory constructor for filter mutation eviction.
  LovDataStatePending.filterChanged({
    LovPendingReasonFailed? retainedFailureReason,
  }) : reason = LovPendingReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for blocked baseline state caused by direct query or filter failures.
  LovDataStatePending.failed({
    required LovErrorOrigin errorOrigin,
    LovModelErrorInfo? errorInfo,
  }) : reason = LovPendingReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "pending";

  /// Resolves the active or preserved error payload across the pending reason chain.
  @override
  LovModelErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this pending state directly failed or carries a retained failure.
  LovPendingReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this pending state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'LovDataState.pending(reason: $reason)';
}

/// Base sealed class for states where lookup items are loaded and retained in RAM.
sealed class LovDataStateLoaded extends LovDataState {
  const LovDataStateLoaded();

  /// Indicates whether the active LOV holds a pending or retained operational error.
  bool get hasError => errorInfo != null;
}

/// Active dataset in RAM is fully fresh, synchronized, and matching active criteria.
final class LovDataStateLoadedFresh extends LovDataStateLoaded {
  const LovDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  LovModelErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LovDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "loadedFresh()";

  @override
  String toString() => 'LovDataState.loadedFresh()';
}

/// Dataset is loaded in RAM but marked stale due to criteria shifts, background failures, or external events.
final class LovDataStateLoadedStale extends LovDataStateLoaded {
  final LovLoadedStateStaleReason reason;

  const LovDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  LovDataStateLoadedStale.event({
    LovLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = LovLoadedStateStaleReasonEvent(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for filter-changed stale state.
  LovDataStateLoadedStale.filterChanged({
    LovLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = LovLoadedStateStaleReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for query-failure stale state.
  LovDataStateLoadedStale.failed({
    required LovErrorOrigin errorOrigin,
    LovModelErrorInfo? errorInfo,
  }) : reason = LovLoadedStateStaleReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [LovModelErrorInfo] from the active reason or retained failure payload.
  @override
  LovModelErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this stale state directly failed or carries a retained failure.
  LovLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this stale state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "loadedStale(${reason.toBriefInfo()})";

  @override
  String toString() => 'LovDataState.loadedStale(reason: $reason)';
}

// =============================================================================
// PENDING REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind a [LovDataStatePending].
sealed class LovPendingReason {
  const LovPendingReason();

  /// Quick check whether this pending state was caused by an execution failure.
  bool get isFailed => this is LovPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial cold loading.
  bool get isInitial => this is LovPendingReasonInitial;

  /// Quick check whether this pending state was triggered by a filter criteria shift.
  bool get isFilterChanged => this is LovPendingReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  LovModelErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the pending reason hierarchy.
  LovPendingReasonFailed? get underlyingFailureReason => switch (this) {
        LovPendingReasonFailed failure => failure,
        LovPendingReasonFilterChanged(:final retainedFailureReason) =>
          retainedFailureReason,
        _ => null,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience constant for initial pending state.
  static const LovPendingReason initial = LovPendingReasonInitial();

  /// Convenience factory for failed pending state.
  static LovPendingReason failed({
    required LovErrorOrigin errorOrigin,
    LovModelErrorInfo? errorInfo,
  }) =>
      LovPendingReasonFailed(errorOrigin: errorOrigin, errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Initial cold baseline loading (first-time loading, no errors encountered yet).
final class LovPendingReasonInitial extends LovPendingReason {
  const LovPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LovPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'LovPendingReason.initial';
}

/// Baseline dataset was evicted and entered pending state because the active filter criteria mutated.
final class LovPendingReasonFilterChanged extends LovPendingReason {
  /// Retained failure state from earlier query attempts (if any).
  final LovPendingReasonFailed? retainedFailureReason;

  const LovPendingReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovPendingReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'LovPendingReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline loading failure where no prior dataset exists (caused by direct query or filter model).
final class LovPendingReasonFailed extends LovPendingReason {
  /// Identifies the root architectural layer or trigger source that caused this failure.
  final LovErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if available.
  @override
  final LovModelErrorInfo? errorInfo;

  const LovPendingReasonFailed({
    required this.errorOrigin,
    required this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovPendingReasonFailed &&
          runtimeType == other.runtimeType &&
          errorOrigin == other.errorOrigin &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorOrigin, errorInfo);

  @override
  String toBriefInfo() =>
      "failed(${errorOrigin.name}${errorInfo == null ? '' : ',err'})";

  @override
  String toString() =>
      'LovPendingReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

// =============================================================================
// LOADED STALE REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind marking a loaded dataset as stale.
sealed class LovLoadedStateStaleReason {
  const LovLoadedStateStaleReason();

  /// Quick check whether data became stale due to an incoming domain event / notification.
  bool get isEvent => this is LovLoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background re-query attempt failed.
  bool get isFailed => this is LovLoadedStateStaleReasonFailed;

  /// Quick check whether data became stale due to a filter criteria shift.
  bool get isFilterChanged => this is LovLoadedStateStaleReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  LovModelErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the stale reason hierarchy.
  LovLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      switch (this) {
        LovLoadedStateStaleReasonFailed failure => failure,
        LovLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
          retainedFailureReason,
        LovLoadedStateStaleReasonFilterChanged(:final retainedFailureReason) =>
          retainedFailureReason,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience constant for event-induced stale reason without previous failure.
  static const LovLoadedStateStaleReason event =
      LovLoadedStateStaleReasonEvent();

  /// Convenience factory for query-failure stale reason.
  static LovLoadedStateStaleReason failed({
    required LovErrorOrigin errorOrigin,
    LovModelErrorInfo? errorInfo,
  }) =>
      LovLoadedStateStaleReasonFailed(
        errorOrigin: errorOrigin,
        errorInfo: errorInfo,
      );

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Baseline dataset is marked stale due to an external mutation event or sync trigger.
final class LovLoadedStateStaleReasonEvent extends LovLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final LovLoadedStateStaleReasonFailed? retainedFailureReason;

  const LovLoadedStateStaleReasonEvent({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovLoadedStateStaleReasonEvent &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "event(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'LovLoadedStateStaleReason.event(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline dataset remains loaded in memory but is marked stale because
/// the active committed filter criteria mutated.
final class LovLoadedStateStaleReasonFilterChanged
    extends LovLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final LovLoadedStateStaleReasonFailed? retainedFailureReason;

  const LovLoadedStateStaleReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovLoadedStateStaleReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'LovLoadedStateStaleReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline dataset is marked stale because a subsequent remote refetch, filter change, or query failed.
final class LovLoadedStateStaleReasonFailed extends LovLoadedStateStaleReason {
  final LovErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed fetch attempt.
  @override
  final LovModelErrorInfo? errorInfo;

  const LovLoadedStateStaleReasonFailed({
    required this.errorOrigin,
    this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LovLoadedStateStaleReasonFailed &&
          runtimeType == other.runtimeType &&
          errorOrigin == other.errorOrigin &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorOrigin, errorInfo);

  @override
  String toBriefInfo() =>
      "failed(${errorOrigin.name}${errorInfo == null ? '' : ',err'})";

  @override
  String toString() =>
      'LovLoadedStateStaleReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}
