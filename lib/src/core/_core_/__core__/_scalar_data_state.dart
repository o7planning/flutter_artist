part of '../core.dart';

/// Root sealed state container for Scalar data lifecycle.
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

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Uninitialized context (Child scalar whose parent has no selected item).
final class ScalarDataStateNone extends ScalarDataState {
  const ScalarDataStateNone();

  @override
  String get name => "none";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ScalarDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() {
    return "none()";
  }

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

  /// Quick accessor to diagnostic error info if available.
  ScalarErrorInfo? get errorInfo => switch (reason) {
        ScalarPendingReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarDataStatePending &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() {
    return "pending(${reason.toBriefInfo()})";
  }

  @override
  String toString() => 'ScalarDataState.pending(reason: $reason)';
}

/// Base sealed class for states where scalar data is loaded and retained in RAM.
sealed class ScalarDataStateLoaded extends ScalarDataState {
  const ScalarDataStateLoaded();
}

/// Active scalar metric in RAM is fully fresh, synchronized, and matching active criteria.
final class ScalarDataStateLoadedFresh extends ScalarDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary fetch or polling operations while the active scalar value remains
  /// completely valid, intact, and fresh.
  ///
  /// This captures failures where the current in-memory content should neither be
  /// evicted nor marked stale, allowing the UI to retain the existing scalar metric
  /// while displaying localized feedback or retry prompts.
  ///
  /// Common scenarios include:
  /// - **Background Polling Failure:** Periodic refresh of a dashboard counter fails due to a network glitch,
  ///   while the displayed metric remains fresh according to the last successful poll.
  /// - **Secondary Metric Calculation Failure:** A dependent sub-calculation failed without corrupting the main metric.
  final ScalarErrorInfo? transientErrorInfo;

  const ScalarDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

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
  String toBriefInfo() {
    return "fresh(${transientErrorInfo == null ? '' : 'err'})";
  }

  @override
  String toString() =>
      'ScalarDataState.loadedFresh(transientError: $transientErrorInfo)';
}

/// Scalar value is loaded in RAM but marked stale due to criteria shifts, background failures, or external events.
final class ScalarDataStateLoadedStale extends ScalarDataStateLoaded {
  final ScalarLoadedStateStaleReason reason;

  const ScalarDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  const ScalarDataStateLoadedStale.event()
      : reason = const ScalarLoadedStateStaleReasonEvent();

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

  /// Quick accessor extracting [ScalarErrorInfo] directly from the stale reason payload.
  ScalarErrorInfo? get errorInfo => reason.errorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() {
    return "stale(${reason.toBriefInfo()})";
  }

  @override
  String toString() => 'ScalarDataState.loadedStale(reason: $reason)';
}

/// Baseline scalar value is marked stale due to an external mutation event or sync trigger.
final class ScalarLoadedStateStaleReasonEvent
    extends ScalarLoadedStateStaleReason {
  const ScalarLoadedStateStaleReasonEvent();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ScalarLoadedStateStaleReasonEvent;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() {
    return "event()";
  }

  @override
  String toString() => 'ScalarLoadedStateStaleReason.event';
}

/// Baseline scalar value is marked stale because a subsequent remote refetch, filter change, or query failed.
final class ScalarLoadedStateStaleReasonFailed
    extends ScalarLoadedStateStaleReason {
  final ScalarErrorOrigin errorOrigin;

  /// Structured diagnostic details regarding the failed fetch attempt.
  @override
  final ScalarErrorInfo? errorInfo;

  ScalarLoadedStateStaleReasonFailed({
    required this.errorOrigin,
    this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScalarLoadedStateStaleReasonFailed &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() {
    return "failed(${errorOrigin.name}${errorInfo == null ? '' : ',err'})";
  }

  @override
  String toString() =>
      'ScalarLoadedStateStaleReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind a [ScalarDataStatePending].
sealed class ScalarPendingReason {
  const ScalarPendingReason();

  String toBriefInfo();

  /// Quick check whether this pending state was caused by an execution failure (direct query, filter, or cascade).
  bool get isFailed => this is ScalarPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial loading.
  bool get isInitial => this is ScalarPendingReasonInitial;

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
  String toString() => 'ScalarPendingReason.initial';

  @override
  String toBriefInfo() {
    return "initial()";
  }
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
  String toBriefInfo() {
    return "failed(${errorOrigin.name}${errorInfo == null ? '' : ',err'})";
  }

  @override
  String toString() =>
      'ScalarPendingReason.failed(origin: $errorOrigin, errorInfo: $errorInfo)';
}

/// Sealed hierarchy representing the specific rationale behind marking a loaded scalar as stale.
sealed class ScalarLoadedStateStaleReason {
  const ScalarLoadedStateStaleReason();

  /// Quick check whether scalar data became stale due to an incoming domain event / notification.
  bool get isEvent => this is ScalarLoadedStateStaleReasonEvent;

  /// Quick check whether scalar data is stale because a background re-query attempt failed.
  bool get isFailed => this is ScalarLoadedStateStaleReasonFailed;

  /// Quick accessor to diagnostic error payload if available.
  ScalarErrorInfo? get errorInfo => switch (this) {
        ScalarLoadedStateStaleReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  /// Convenience constant for event-induced stale reason.
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
