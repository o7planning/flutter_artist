part of '../core.dart';

/// Root sealed state container for Scalar data lifecycle.
@immutable
sealed class ScalarDataState {
  const ScalarDataState();

  String get name;

  String toBriefInfo();

  // Common quick getters
  bool get isNone => this is ScalarDataStateNone;

  bool get isPending => this is ScalarDataStatePending;

  bool get isLoaded => this is ScalarDataStateLoaded;

  bool get isFresh => this is ScalarDataStateLoadedFresh;

  bool get isStale => this is ScalarDataStateLoadedStale;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  ScalarErrorInfo? get errorInfo;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Uninitialized context (e.g., Child scalar whose parent has no selected item or value).
final class ScalarDataStateNone extends ScalarDataState {
  const ScalarDataStateNone();

  @override
  String get name => "none";

  @override
  ScalarErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ScalarDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'ScalarDataState.none()';
}

/// Cold baseline loading state (No prior active scalar value in RAM, or evicted).
final class ScalarDataStatePending extends ScalarDataState {
  final ScalarPendingReason reason;

  const ScalarDataStatePending({
    this.reason = const ScalarPendingReasonInitial(),
  });

  /// Factory constructor for standard cold initial loading.
  const ScalarDataStatePending.initial()
      : reason = const ScalarPendingReasonInitial();

  /// Factory constructor for filter mutation eviction.
  ScalarDataStatePending.filterChanged({
    ScalarPendingReasonFailed? retainedFailureReason,
  }) : reason = ScalarPendingReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for blocked baseline state caused by direct query, filter, or upstream cascade failures.
  ScalarDataStatePending.failed({
    required ScalarErrorOrigin errorOrigin,
    ScalarErrorInfo? errorInfo,
  }) : reason = ScalarPendingReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "pending";

  /// Resolves the active or preserved error payload across the pending reason chain.
  @override
  ScalarErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this pending state directly failed or carries a retained failure.
  ScalarPendingReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this pending state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'ScalarDataState.pending(reason: $reason)';
}

/// Base sealed class for states where scalar data is loaded and retained in RAM.
sealed class ScalarDataStateLoaded extends ScalarDataState {
  const ScalarDataStateLoaded();

  /// Indicates whether the active scalar holds a pending or retained operational error.
  bool get hasError => errorInfo != null;
}

/// Active scalar metric in RAM is fully fresh, synchronized, and matching active criteria.
final class ScalarDataStateLoadedFresh extends ScalarDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary fetch or polling operations while the active scalar value remains
  /// completely valid, intact, and fresh.
  final ScalarErrorInfo? transientErrorInfo;

  const ScalarDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

  @override
  ScalarErrorInfo? get errorInfo => transientErrorInfo;

  /// Quick check if the fresh state carries a transient operation error.
  bool get hasTransientError => transientErrorInfo != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarDataStateLoadedFresh &&
          runtimeType == other.runtimeType &&
          transientErrorInfo == other.transientErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, transientErrorInfo);

  @override
  String toBriefInfo() => "fresh(${transientErrorInfo == null ? '' : 'err'})";

  @override
  String toString() =>
      'ScalarDataState.loadedFresh(transientError: $transientErrorInfo)';
}

/// Scalar value is loaded in RAM but marked stale due to criteria shifts, background failures, or external events.
final class ScalarDataStateLoadedStale extends ScalarDataStateLoaded {
  final ScalarLoadedStateStaleReason reason;

  const ScalarDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  ScalarDataStateLoadedStale.event({
    ScalarLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = ScalarLoadedStateStaleReasonEvent(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for filter-changed stale state.
  ScalarDataStateLoadedStale.filterChanged({
    ScalarLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = ScalarLoadedStateStaleReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for query-failure stale state.
  ScalarDataStateLoadedStale.failed({
    required ScalarErrorOrigin errorOrigin,
    ScalarErrorInfo? errorInfo,
  }) : reason = ScalarLoadedStateStaleReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [ScalarErrorInfo] from the active reason or retained failure payload.
  @override
  ScalarErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this stale state directly failed or carries a retained failure.
  ScalarLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this stale state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "stale(${reason.toBriefInfo()})";

  @override
  String toString() => 'ScalarDataState.loadedStale(reason: $reason)';
}

// =============================================================================
// PENDING REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind a [ScalarDataStatePending].
sealed class ScalarPendingReason {
  const ScalarPendingReason();

  String toBriefInfo();

  /// Quick check whether this pending state was caused by an execution failure (direct query, filter, or cascade).
  bool get isFailed => this is ScalarPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial loading.
  bool get isInitial => this is ScalarPendingReasonInitial;

  /// Quick check whether this pending state was triggered by a filter criteria shift.
  bool get isFilterChanged => this is ScalarPendingReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  ScalarErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the pending reason hierarchy.
  ScalarPendingReasonFailed? get underlyingFailureReason => switch (this) {
        ScalarPendingReasonFailed failure => failure,
        ScalarPendingReasonFilterChanged(:final retainedFailureReason) =>
          retainedFailureReason,
        _ => null,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience factory for initial pending state.
  static const ScalarPendingReason initial = ScalarPendingReasonInitial();

  /// Convenience factory for failed pending state.
  static ScalarPendingReason failed({
    required ScalarErrorOrigin errorOrigin,
    ScalarErrorInfo? errorInfo,
  }) =>
      ScalarPendingReasonFailed(
        errorOrigin: errorOrigin,
        errorInfo: errorInfo,
      );

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Initial cold baseline loading (First-time loading, no errors encountered yet).
final class ScalarPendingReasonInitial extends ScalarPendingReason {
  const ScalarPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ScalarPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'ScalarPendingReason.initial';
}

/// Baseline metric or value was invalidated and entered pending state because the active filter criteria mutated.
final class ScalarPendingReasonFilterChanged extends ScalarPendingReason {
  /// Retained failure state from earlier query attempts (if any).
  final ScalarPendingReasonFailed? retainedFailureReason;

  const ScalarPendingReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarPendingReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'ScalarPendingReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline loading failure where no prior scalar exists (caused by direct query, filter model, or upstream parent cascade).
final class ScalarPendingReasonFailed extends ScalarPendingReason {
  /// Identifies the root architectural layer or trigger source that caused this failure.
  final ScalarErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if available.
  final ScalarErrorInfo? errorInfo;

  const ScalarPendingReasonFailed({
    required this.errorOrigin,
    required this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarPendingReasonFailed &&
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
      'ScalarPendingReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

// =============================================================================
// LOADED STALE REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind marking a loaded scalar as stale.
sealed class ScalarLoadedStateStaleReason {
  const ScalarLoadedStateStaleReason();

  /// Quick check whether scalar data became stale due to an incoming domain event / notification.
  bool get isEvent => this is ScalarLoadedStateStaleReasonEvent;

  /// Quick check whether scalar data is stale because a background re-query attempt failed.
  bool get isFailed => this is ScalarLoadedStateStaleReasonFailed;

  /// Quick check whether metric became stale due to a filter criteria shift.
  bool get isFilterChanged => this is ScalarLoadedStateStaleReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  ScalarErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the stale reason hierarchy.
  ScalarLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      switch (this) {
        ScalarLoadedStateStaleReasonFailed failure => failure,
        ScalarLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
          retainedFailureReason,
        ScalarLoadedStateStaleReasonFilterChanged(
          :final retainedFailureReason
        ) =>
          retainedFailureReason,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience constant for event-induced stale reason without previous failure.
  static const ScalarLoadedStateStaleReason event =
      ScalarLoadedStateStaleReasonEvent();

  /// Convenience factory for query-failure stale reason.
  static ScalarLoadedStateStaleReason failed({
    required ScalarErrorOrigin errorOrigin,
    ScalarErrorInfo? errorInfo,
  }) =>
      ScalarLoadedStateStaleReasonFailed(
        errorOrigin: errorOrigin,
        errorInfo: errorInfo,
      );

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Baseline scalar value is marked stale due to an external mutation event or sync trigger.
final class ScalarLoadedStateStaleReasonEvent
    extends ScalarLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final ScalarLoadedStateStaleReasonFailed? retainedFailureReason;

  const ScalarLoadedStateStaleReasonEvent({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarLoadedStateStaleReasonEvent &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "event(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'ScalarLoadedStateStaleReason.event(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline metric or value remains loaded in memory but is marked stale because
/// the active committed filter criteria mutated.
final class ScalarLoadedStateStaleReasonFilterChanged
    extends ScalarLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final ScalarLoadedStateStaleReasonFailed? retainedFailureReason;

  const ScalarLoadedStateStaleReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarLoadedStateStaleReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'ScalarLoadedStateStaleReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline scalar value is marked stale because a subsequent remote refetch, filter change, or query failed.
final class ScalarLoadedStateStaleReasonFailed
    extends ScalarLoadedStateStaleReason {
  final ScalarErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed fetch attempt.
  @override
  final ScalarErrorInfo? errorInfo;

  const ScalarLoadedStateStaleReasonFailed({
    required this.errorOrigin,
    this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarLoadedStateStaleReasonFailed &&
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
      'ScalarLoadedStateStaleReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}
