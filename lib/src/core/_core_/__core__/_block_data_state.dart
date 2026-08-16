part of '../core.dart';

/// Root sealed state container for Block data lifecycle
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

/// Uninitialized context (Child block whose parent has no selected item)
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

/// Cold baseline loading (No data in memory)
final class BlockDataStatePending extends BlockDataState {
  final PendingReason reason;

  const BlockDataStatePending({
    this.reason = const PendingReasonInitial(),
  });

  /// Factory for standard initial loading
  const BlockDataStatePending.initial() : reason = const PendingReasonInitial();

  /// Factory for failed baseline loading with optional diagnostic payload
  BlockDataStatePending.fetchFailed({BlockErrorInfo? errorInfo})
      : reason = PendingReasonFetchFailed(errorInfo: errorInfo);

  @override
  String get name => "pending";

  /// Quick accessor to diagnostic error info if available
  BlockErrorInfo? get errorInfo => switch (reason) {
        PendingReasonFetchFailed(:final errorInfo) => errorInfo,
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

/// Data is loaded in RAM
sealed class BlockDataStateLoaded extends BlockDataState {
  const BlockDataStateLoaded();
}

/// Data is fully fresh and synchronized
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

/// Data is loaded in RAM but marked stale.
final class BlockDataStateLoadedStale extends BlockDataStateLoaded {
  final LoadedStateStaleReason reason;

  const BlockDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  const BlockDataStateLoadedStale.event()
      : reason = const LoadedStateStaleReasonEvent();

  /// Factory constructor for fetch-failure stale state.
  BlockDataStateLoadedStale.fetchFailed({BlockErrorInfo? errorInfo})
      : reason = LoadedStateStaleReasonFetchFailed(errorInfo: errorInfo);

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
final class LoadedStateStaleReasonEvent extends LoadedStateStaleReason {
  const LoadedStateStaleReasonEvent();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LoadedStateStaleReasonEvent;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'LoadedStateStaleReason.event';
}

/// Baseline dataset is marked stale because a subsequent remote refetch / re-query failed.
final class LoadedStateStaleReasonFetchFailed extends LoadedStateStaleReason {
  /// Structured diagnostic details regarding the failed fetch attempt.
  final BlockErrorInfo? errorInfo;

  LoadedStateStaleReasonFetchFailed({this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadedStateStaleReasonFetchFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toString() =>
      'LoadedStateStaleReason.fetchFailed(errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind a [BlockDataStatePending].
sealed class PendingReason {
  const PendingReason();

  /// Quick check whether this pending state was caused by a fetch failure.
  bool get isFetchFailed => this is PendingReasonFetchFailed;

  /// Quick check whether this pending state is uninitialized / initial loading.
  bool get isInitial => this is PendingReasonInitial;

  /// Convenience factory for initial pending state.
  static const PendingReason initial = PendingReasonInitial();

  /// Convenience factory for fetch failed pending state.
  static PendingReason fetchFailed({BlockErrorInfo? errorInfo}) =>
      PendingReasonFetchFailed(errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Initial cold baseline loading (First-time loading, no errors encountered yet).
final class PendingReasonInitial extends PendingReason {
  const PendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'PendingReason.initial';
}

/// Baseline fetch failure where no prior dataset exists or context was scrubbed.
final class PendingReasonFetchFailed extends PendingReason {
  /// Structured diagnostic details regarding the failed query attempt.
  final BlockErrorInfo? errorInfo;

  const PendingReasonFetchFailed({required this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingReasonFetchFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toString() => 'PendingReason.fetchFailed(errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind marking loaded dataset as stale.
sealed class LoadedStateStaleReason {
  const LoadedStateStaleReason();

  /// Quick check whether data became stale due to an incoming domain event / notification.
  bool get isEvent => this is LoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background re-query attempt failed.
  bool get isFetchFailed => this is LoadedStateStaleReasonFetchFailed;

  /// Quick accessor to diagnostic error payload if available.
  BlockErrorInfo? get errorInfo => switch (this) {
        LoadedStateStaleReasonFetchFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  /// Convenience constant for event-induced stale reason.
  static const LoadedStateStaleReason event = LoadedStateStaleReasonEvent();

  /// Convenience factory for fetch-failure stale reason.
  static LoadedStateStaleReason fetchFailed({BlockErrorInfo? errorInfo}) =>
      LoadedStateStaleReasonFetchFailed(errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}
