part of '../core.dart';

/// Root sealed state container for overall Prozess lifecycle readiness and pipeline transitions.
@immutable
sealed class ProzessDataState implements DataState {
  const ProzessDataState();

  String get name;

  bool get isPending => this is ProzessDataStatePending;

  bool get isLoaded => this is ProzessDataStateLoaded;

  bool get isLoadedFresh => this is ProzessDataStateLoadedFresh;

  bool get isLoadedStale => this is ProzessDataStateLoadedStale;

  bool get isTransitionAttempted => this is ProzessDataStateTransitionAttempted;

  bool get isTransitionSuccess => this is ProzessDataStateTransitionSuccess;

  bool get isTransitionFailed => this is ProzessDataStateTransitionFailed;

  bool get isCompleted => this is ProzessDataStateCompleted;

  bool get isAborted => this is ProzessDataStateAborted;

  /// Quick accessor to diagnostic error payload across error-carrying states.
  ProzessErrorInfo? get errorInfo;

  bool get hasError => errorInfo != null;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

// =============================================================================
// 1. PENDING STATE HIERARCHY
// =============================================================================

/// Prozess is preparing its initial context or failed during initial setup.
final class ProzessDataStatePending extends ProzessDataState {
  final ProzessPendingReason reason;

  const ProzessDataStatePending({
    this.reason = const ProzessPendingReasonInitial(),
  });

  const ProzessDataStatePending.initial()
      : reason = const ProzessPendingReasonInitial();

  ProzessDataStatePending.failed({
    required ProzessErrorInfo errorInfo,
  }) : reason = ProzessPendingReasonFailed(errorInfo: errorInfo);

  @override
  String get name => "pending";

  @override
  ProzessErrorInfo? get errorInfo => reason.errorInfo;

  bool get hasFailure => reason.isFailed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProzessDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'ProzessDataState.pending(reason: $reason)';
}

/// Sealed rationale hierarchy behind a [ProzessDataStatePending].
sealed class ProzessPendingReason {
  const ProzessPendingReason();

  String toBriefInfo();

  bool get isInitial => this is ProzessPendingReasonInitial;

  bool get isFailed => this is ProzessPendingReasonFailed;

  ProzessErrorInfo? get errorInfo => switch (this) {
        ProzessPendingReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

final class ProzessPendingReasonInitial extends ProzessPendingReason {
  const ProzessPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'ProzessPendingReason.initial';
}

final class ProzessPendingReasonFailed extends ProzessPendingReason {
  @override
  final ProzessErrorInfo errorInfo;

  const ProzessPendingReasonFailed({required this.errorInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProzessPendingReasonFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "failed(err)";

  @override
  String toString() => 'ProzessPendingReason.failed(errorInfo: $errorInfo)';
}

// =============================================================================
// 2. LOADED STATE HIERARCHY
// =============================================================================

sealed class ProzessDataStateLoaded extends ProzessDataState {
  const ProzessDataStateLoaded();

  @override
  ProzessErrorInfo? get errorInfo => null;
}

final class ProzessDataStateLoadedFresh extends ProzessDataStateLoaded {
  const ProzessDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "loadedFresh()";

  @override
  String toString() => 'ProzessDataState.loadedFresh()';
}

final class ProzessDataStateLoadedStale extends ProzessDataStateLoaded {
  final ProzessErrorInfo? staleErrorInfo;

  const ProzessDataStateLoadedStale({this.staleErrorInfo});

  @override
  String get name => "loaded + stale";

  @override
  ProzessErrorInfo? get errorInfo => staleErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProzessDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          staleErrorInfo == other.staleErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, staleErrorInfo);

  @override
  String toBriefInfo() => "loadedStale(${staleErrorInfo == null ? '' : 'err'})";

  @override
  String toString() =>
      'ProzessDataState.loadedStale(errorInfo: $staleErrorInfo)';
}

// =============================================================================
// 3. TRANSITIONING STATE HIERARCHY
// =============================================================================

/// Base sealed class when prozess is actively determining or transitioning to the next stage.
sealed class ProzessDataStateTransitionAttempted extends ProzessDataState {
  const ProzessDataStateTransitionAttempted();
}

/// Stage transition and next-stage determination completed successfully.
final class ProzessDataStateTransitionSuccess
    extends ProzessDataStateTransitionAttempted {
  const ProzessDataStateTransitionSuccess();

  @override
  String get name => "transitioning + success";

  @override
  ProzessErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessDataStateTransitionSuccess;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "transitioningSuccess()";

  @override
  String toString() => 'ProzessDataState.transitioningSuccess()';
}

/// Stage transition or next-stage determination failed (e.g., determineNextStep error);
/// allows executor or user to inspect and retry.
final class ProzessDataStateTransitionFailed
    extends ProzessDataStateTransitionAttempted {
  final ProzessErrorInfo transitionErrorInfo;

  const ProzessDataStateTransitionFailed({
    required this.transitionErrorInfo,
  });

  @override
  String get name => "transitioning + failed";

  @override
  ProzessErrorInfo? get errorInfo => transitionErrorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProzessDataStateTransitionFailed &&
          runtimeType == other.runtimeType &&
          transitionErrorInfo == other.transitionErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, transitionErrorInfo);

  @override
  String toBriefInfo() => "transitioningFailed(err)";

  @override
  String toString() =>
      'ProzessDataState.transitioningFailed(errorInfo: $transitionErrorInfo)';
}

// =============================================================================
// 4. COMPLETED STATE
// =============================================================================

final class ProzessDataStateCompleted extends ProzessDataState {
  const ProzessDataStateCompleted();

  @override
  String get name => "completed";

  @override
  ProzessErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessDataStateCompleted;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "completed()";

  @override
  String toString() => 'ProzessDataState.completed()';
}

// =============================================================================
// 5. ABORTED STATE
// =============================================================================

final class ProzessDataStateAborted extends ProzessDataState {
  final String? reason;

  const ProzessDataStateAborted({this.reason});

  @override
  String get name => "aborted";

  @override
  ProzessErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProzessDataStateAborted &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "aborted(${reason ?? ''})";

  @override
  String toString() => 'ProzessDataState.aborted(reason: $reason)';
}
