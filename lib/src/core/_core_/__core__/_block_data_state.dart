part of '../core.dart';

/// Root sealed state container for Block data lifecycle.
sealed class BlockDataState {
  const BlockDataState();

  String get name;

  // Common quick getters
  bool get isNone => this is BlockDataStateNone;

  bool get isPending => this is BlockDataStatePending;

  bool get isLoaded => this is BlockDataStateLoaded;

  bool get isFresh => this is BlockDataStateLoadedFresh;

  bool get isStale => this is BlockDataStateLoadedStale;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Uninitialized context (Child block whose parent has no selected item).
final class BlockDataStateNone extends BlockDataState {
  const BlockDataStateNone();

  @override
  String get name => "none";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlockDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

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

  /// Quick accessor to diagnostic error info if available.
  BlockErrorInfo? get errorInfo => switch (reason) {
        BlockPendingReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() => 'BlockDataState.pending(reason: $reason)';
}

/// Base sealed class for states where data is loaded and retained in RAM.
sealed class BlockDataStateLoaded extends BlockDataState {
  const BlockDataStateLoaded();
}

/// Active dataset in RAM is fully fresh, synchronized, and matching active criteria.
final class BlockDataStateLoadedFresh extends BlockDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary fetch operations while the active baseline dataset remains completely
  /// valid, intact, and fresh.
  ///
  /// This captures failures where the current in-memory content should neither be
  /// evicted nor marked stale, allowing the UI to retain existing items while
  /// displaying localized feedback or retry prompts.
  ///
  /// Common scenarios include:
  /// - **Page Shifting Failure:** The user successfully loads Page 1 (`BlockDataStateLoadedFresh`),
  ///   subsequently navigates to Page 2, but the request fails. The block reverts/stays on Page 1
  ///   data (which is still 100% fresh and matching active criteria) while carrying this error.
  /// - **Incremental Fetch/Append Failure (`queryMore`):** The user has valid Page 1 rows on screen,
  ///   triggers infinite scroll/load-more to append Page 2, but the network drops. Page 1 items
  ///   remain intact and fresh, while this error indicates that the tail append attempt failed.
  final BlockErrorInfo? transientErrorInfo;

  const BlockDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

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
  String toString() =>
      'BlockDataState.loadedFresh(transientError: $transientErrorInfo)';
}

/// Dataset is loaded in RAM but marked stale due to criteria shifts, background failures, or external events.
final class BlockDataStateLoadedStale extends BlockDataStateLoaded {
  final BlockLoadedStateStaleReason reason;

  const BlockDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  const BlockDataStateLoadedStale.event()
      : reason = const BlockLoadedStateStaleReasonEvent();

  /// Factory constructor for query-failure stale state.
  BlockDataStateLoadedStale.failed({BlockErrorInfo? errorInfo})
      : reason = BlockLoadedStateStaleReasonFailed(errorInfo: errorInfo);

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [BlockErrorInfo] directly from the stale reason payload.
  BlockErrorInfo? get errorInfo => reason.errorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() => 'BlockDataState.loadedStale(reason: $reason)';
}

/// Baseline dataset is marked stale due to an external mutation event or sync trigger.
final class BlockLoadedStateStaleReasonEvent
    extends BlockLoadedStateStaleReason {
  const BlockLoadedStateStaleReasonEvent();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlockLoadedStateStaleReasonEvent;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BlockLoadedStateStaleReason.event';
}

/// Baseline dataset is marked stale because a subsequent remote refetch, filter change, or query failed.
final class BlockLoadedStateStaleReasonFailed
    extends BlockLoadedStateStaleReason {
  /// Structured diagnostic details regarding the failed fetch attempt.
  final BlockErrorInfo? errorInfo;

  BlockLoadedStateStaleReasonFailed({this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockLoadedStateStaleReasonFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toString() =>
      'BlockLoadedStateStaleReason.failed(errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind a [BlockDataStatePending].
sealed class BlockPendingReason {
  const BlockPendingReason();

  /// Quick check whether this pending state was caused by an execution failure (direct query, filter, or cascade).
  bool get isFailed => this is BlockPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial loading.
  bool get isInitial => this is BlockPendingReasonInitial;

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
  String toString() => 'PendingReason.initial';
}

/// Baseline loading failure where no prior dataset exists (caused by direct query, filter model, or upstream parent cascade).
final class BlockPendingReasonFailed extends BlockPendingReason {
  /// Identifies the root architectural layer or trigger source that caused this failure.
  final BlockErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed query attempt, if available.
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
  String toString() =>
      'PendingReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind marking a loaded dataset as stale.
sealed class BlockLoadedStateStaleReason {
  const BlockLoadedStateStaleReason();

  /// Quick check whether data became stale due to an incoming domain event / notification.
  bool get isEvent => this is BlockLoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background re-query attempt failed.
  bool get isFailed => this is BlockLoadedStateStaleReasonFailed;

  /// Quick accessor to diagnostic error payload if available.
  BlockErrorInfo? get errorInfo => switch (this) {
        BlockLoadedStateStaleReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  /// Convenience constant for event-induced stale reason.
  static const BlockLoadedStateStaleReason event =
      BlockLoadedStateStaleReasonEvent();

  /// Convenience factory for query-failure stale reason.
  static BlockLoadedStateStaleReason failed({BlockErrorInfo? errorInfo}) =>
      BlockLoadedStateStaleReasonFailed(errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}
