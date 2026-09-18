part of '../core.dart';

/// Root sealed state container for Block data lifecycle.
@immutable
sealed class BlockDataState {
  const BlockDataState();

  String get name;

  // Common quick getters
  bool get isNone => this is BlockDataStateNone;

  bool get isPending => this is BlockDataStatePending;

  bool get isLoaded => this is BlockDataStateLoaded;

  bool get isFresh => this is BlockDataStateLoadedFresh;

  bool get isStale => this is BlockDataStateLoadedStale;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  BlockErrorInfo? get errorInfo;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Uninitialized context (e.g., Child block whose parent has no selected item).
final class BlockDataStateNone extends BlockDataState {
  const BlockDataStateNone();

  @override
  String get name => "none";

  @override
  BlockErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlockDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'BlockDataState.none()';
}

/// Cold baseline loading state (No prior active dataset in RAM, or evicted).
final class BlockDataStatePending extends BlockDataState {
  final BlockPendingReason reason;

  const BlockDataStatePending({
    this.reason = const BlockPendingReasonInitial(),
  });

  /// Factory constructor for standard cold initial loading.
  const BlockDataStatePending.initial()
      : reason = const BlockPendingReasonInitial();

  /// Factory constructor for filter mutation eviction.
  BlockDataStatePending.filterChanged({
    BlockPendingReasonFailed? retainedFailureReason,
  }) : reason = BlockPendingReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for blocked baseline state caused by direct query, filter, or upstream cascade failures.
  BlockDataStatePending.failed({
    required BlockErrorOrigin errorOrigin,
    BlockErrorInfo? errorInfo,
  }) : reason = BlockPendingReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "pending";

  /// Resolves the active or preserved error payload across the pending reason chain.
  @override
  BlockErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this pending state directly failed or carries a retained failure.
  BlockPendingReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this pending state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'BlockDataState.pending(reason: $reason)';
}

/// Base sealed class for states where data is loaded and retained in RAM.
sealed class BlockDataStateLoaded extends BlockDataState {
  const BlockDataStateLoaded();

  /// Indicates whether the active block holds a pending or retained operational error.
  bool get hasError => errorInfo != null;
}

/// Active dataset in RAM is fully fresh, synchronized, and matching active criteria.
final class BlockDataStateLoadedFresh extends BlockDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary fetch operations while the active baseline dataset remains completely
  /// valid, intact, and fresh.
  final BlockErrorInfo? transientErrorInfo;

  const BlockDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

  @override
  BlockErrorInfo? get errorInfo => transientErrorInfo;

  /// Quick check if the fresh state carries a transient operation error.
  bool get hasTransientError => transientErrorInfo != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockDataStateLoadedFresh &&
          runtimeType == other.runtimeType &&
          transientErrorInfo == other.transientErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, transientErrorInfo);

  @override
  String toBriefInfo() =>
      "fresh(${transientErrorInfo == null ? '' : 'transientErr'})";

  @override
  String toString() =>
      'BlockDataState.loadedFresh(transientError: $transientErrorInfo)';
}

/// Dataset is loaded in RAM but marked stale due to criteria shifts, background failures, or external events.
final class BlockDataStateLoadedStale extends BlockDataStateLoaded {
  final BlockLoadedStateStaleReason reason;

  const BlockDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  BlockDataStateLoadedStale.event({
    BlockLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = BlockLoadedStateStaleReasonEvent(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for filter-changed stale state.
  BlockDataStateLoadedStale.filterChanged({
    BlockLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = BlockLoadedStateStaleReasonFilterChanged(
          retainedFailureReason: retainedFailureReason,
        );

  /// Factory constructor for query-failure stale state.
  BlockDataStateLoadedStale.failed({
    required BlockErrorOrigin errorOrigin,
    BlockErrorInfo? errorInfo,
  }) : reason = BlockLoadedStateStaleReasonFailed(
          errorOrigin: errorOrigin,
          errorInfo: errorInfo,
        );

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [BlockErrorInfo] from the active reason or retained failure payload.
  @override
  BlockErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this stale state directly failed or carries a retained failure.
  BlockLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this stale state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "stale(${reason.toBriefInfo()})";

  @override
  String toString() => 'BlockDataState.loadedStale(reason: $reason)';
}

// =============================================================================
// PENDING REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind a [BlockDataStatePending].
sealed class BlockPendingReason {
  const BlockPendingReason();

  /// Quick check whether this pending state was caused by an execution failure (direct query, filter, or cascade).
  bool get isFailed => this is BlockPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial cold loading.
  bool get isInitial => this is BlockPendingReasonInitial;

  /// Quick check whether this pending state was triggered by a filter criteria shift.
  bool get isFilterChanged => this is BlockPendingReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  BlockErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the pending reason hierarchy.
  BlockPendingReasonFailed? get underlyingFailureReason => switch (this) {
        BlockPendingReasonFailed failure => failure,
        BlockPendingReasonFilterChanged(:final retainedFailureReason) =>
          retainedFailureReason,
        _ => null,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience factory for initial pending state.
  static const BlockPendingReason initial = BlockPendingReasonInitial();

  /// Convenience factory for failed pending state.
  static BlockPendingReason failed({
    required BlockErrorOrigin errorOrigin,
    BlockErrorInfo? errorInfo,
  }) =>
      BlockPendingReasonFailed(errorOrigin: errorOrigin, errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Initial cold baseline loading (First-time loading, no errors encountered yet).
final class BlockPendingReasonInitial extends BlockPendingReason {
  const BlockPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlockPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'BlockPendingReason.initial';
}

/// Baseline dataset was evicted and entered pending state because the active filter criteria mutated.
final class BlockPendingReasonFilterChanged extends BlockPendingReason {
  /// Retained failure state from earlier query attempts (if any).
  final BlockPendingReasonFailed? retainedFailureReason;

  const BlockPendingReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockPendingReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'BlockPendingReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline loading failure where no prior dataset exists (caused by direct query, filter model, or upstream parent cascade).
final class BlockPendingReasonFailed extends BlockPendingReason {
  /// Identifies the root architectural layer or trigger source that caused this failure.
  final BlockErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if available.
  @override
  final BlockErrorInfo? errorInfo;

  const BlockPendingReasonFailed({
    required this.errorOrigin,
    required this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockPendingReasonFailed &&
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
      'BlockPendingReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

// =============================================================================
// LOADED STALE REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind marking a loaded dataset as stale.
sealed class BlockLoadedStateStaleReason {
  const BlockLoadedStateStaleReason();

  /// Quick check whether data became stale due to an incoming domain event / notification.
  bool get isEvent => this is BlockLoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background re-query attempt failed.
  bool get isFailed => this is BlockLoadedStateStaleReasonFailed;

  /// Quick check whether data became stale due to a filter criteria shift.
  bool get isFilterChanged => this is BlockLoadedStateStaleReasonFilterChanged;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  BlockErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the stale reason hierarchy.
  BlockLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      switch (this) {
        BlockLoadedStateStaleReasonFailed failure => failure,
        BlockLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
          retainedFailureReason,
        BlockLoadedStateStaleReasonFilterChanged(
          :final retainedFailureReason
        ) =>
          retainedFailureReason,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience constant for event-induced stale reason without previous failure.
  static const BlockLoadedStateStaleReason event =
      BlockLoadedStateStaleReasonEvent();

  /// Convenience factory for query-failure stale reason.
  static BlockLoadedStateStaleReason failed({
    required BlockErrorOrigin errorOrigin,
    BlockErrorInfo? errorInfo,
  }) =>
      BlockLoadedStateStaleReasonFailed(
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
final class BlockLoadedStateStaleReasonEvent
    extends BlockLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final BlockLoadedStateStaleReasonFailed? retainedFailureReason;

  const BlockLoadedStateStaleReasonEvent({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockLoadedStateStaleReasonEvent &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "event(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'BlockLoadedStateStaleReason.event(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline dataset remains loaded in memory but is marked stale because
/// the active committed filter criteria mutated.
final class BlockLoadedStateStaleReasonFilterChanged
    extends BlockLoadedStateStaleReason {
  /// Retained failure state from earlier query attempts (if any).
  final BlockLoadedStateStaleReasonFailed? retainedFailureReason;

  const BlockLoadedStateStaleReasonFilterChanged({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockLoadedStateStaleReasonFilterChanged &&
          runtimeType == other.runtimeType &&
          retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "filterChanged(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'BlockLoadedStateStaleReason.filterChanged(retainedFailureReason: $retainedFailureReason)';
}

/// Baseline dataset is marked stale because a subsequent remote refetch, filter change, or query failed.
final class BlockLoadedStateStaleReasonFailed
    extends BlockLoadedStateStaleReason {
  final BlockErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed fetch attempt.
  @override
  final BlockErrorInfo? errorInfo;

  const BlockLoadedStateStaleReasonFailed({
    required this.errorOrigin,
    this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockLoadedStateStaleReasonFailed &&
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
      'BlockLoadedStateStaleReason.failed(origin:$errorOrigin, errorInfo: $errorInfo)';
}
