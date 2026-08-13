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
  const BlockDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlockDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BlockDataState.loadedFresh()';
}

/// Data is loaded but marked stale
final class BlockDataStateLoadedStale extends BlockDataStateLoaded {
  final LoadedStateStaleReason reason;

  const BlockDataStateLoadedStale({required this.reason});

  @override
  String get name => "loaded + stale";

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
