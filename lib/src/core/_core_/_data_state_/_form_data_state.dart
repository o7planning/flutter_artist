part of '../core.dart';

/// Root sealed state container for BaseFormModel lifecycle (covering Block, Task, and Stage form components).
@immutable
sealed class FormDataState implements DataState {
  const FormDataState();

  String get name;

  // Common quick getters
  bool get isNone => this is FormDataStateNone;

  bool get isPending => this is FormDataStatePending;

  bool get isFatalError => this is FormDataStateFatalError;

  bool get isLoaded => this is FormDataStateLoaded;

  bool get isFresh => this is FormDataStateLoadedFresh;

  bool get isStale => this is FormDataStateLoadedStale;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  ErrorInfo? get errorInfo;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Form has no target item or host context assigned and remains dormant.
final class FormDataStateNone extends FormDataState {
  const FormDataStateNone();

  @override
  String get name => "none";

  @override
  ErrorInfo? get errorInfo => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FormDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'FormDataState.none';
}

/// Cold baseline loading state for the form (No prior valid dataset in RAM, or evicted).
final class FormDataStatePending extends FormDataState {
  final FormPendingReason reason;

  const FormDataStatePending({
    this.reason = const FormPendingReasonInitial(),
  });

  /// Factory constructor for standard cold initial loading.
  const FormDataStatePending.initial()
      : reason = const FormPendingReasonInitial();

  /// Factory constructor for host context shift or refresh eviction.
  FormDataStatePending.hostDataRefreshed({
    FormPendingReasonFailed? retainedFailureReason,
  }) : reason = FormPendingReasonHostDataRefreshed(
    retainedFailureReason: retainedFailureReason,
  );

  /// Factory constructor for blocked baseline state caused by direct setup or loading failures.
  FormDataStatePending.failed({
    required ErrorInfo errorInfo,
  }) : reason = FormPendingReasonFailed(
    errorInfo: errorInfo,
  );

  @override
  String get name => "pending";

  /// Resolves the active or preserved error payload across the pending reason chain.
  @override
  ErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this pending state directly failed or carries a retained failure.
  FormPendingReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this pending state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormDataStatePending &&
              runtimeType == other.runtimeType &&
              reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "pending(${reason.toBriefInfo()})";

  @override
  String toString() => 'FormDataState.pending(reason: $reason)';
}

/// Form bootstrapping/initialization encountered an unrecoverable structural failure.
///
/// ### Architectural Significance & Purpose:
/// Unlike transient field-level errors (which occur during runtime interactions while the form remains operational),
/// a [FormDataStateFatalError] represents a **severe structural failure** during the initial bootstrapping phase
/// (e.g., failing to load the primary `ITEM_DETAIL` for a Block, failing to resolve baseline `INIT_DATA` for a Task,
/// or failing to evaluate critical initial form metadata/options).
///
/// **Behavioral Contract:**
/// * When a form enters this state, it is **strictly locked from user interaction** (`isEnabled()` returns `false`).
/// * It prevents the user from submitting corrupted or half-baked data.
/// * It forces an explicit intervention (such as clicking a fatal error inspection dialog or triggering a hard reload)
///   before the form is allowed to recover back to a [FormDataStatePending] or [FormDataStateLoadedFresh] state.
final class FormDataStateFatalError extends FormDataState {
  /// Structured diagnostic error details regarding the unrecoverable bootstrap/initialization failure.
  @override
  final ErrorInfo errorInfo;

  const FormDataStateFatalError({required this.errorInfo});

  @override
  String get name => "fatalError";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormDataStateFatalError &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "fatalError(err)";

  @override
  String toString() => 'FormDataState.fatalError(errorInfo: $errorInfo)';
}

/// Base sealed class for states where form data is loaded and retained in RAM.
sealed class FormDataStateLoaded extends FormDataState {
  const FormDataStateLoaded();

  /// Indicates whether the active form holds a pending or retained operational error.
  bool get hasError => errorInfo != null;
}

/// Active form data in RAM is fully fresh, synchronized, and ready for user interactions.
final class FormDataStateLoadedFresh extends FormDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary field operations (e.g., a failed cascading dropdown like Department options
  /// due to a temporary network glitch) while the active baseline form data remains
  /// completely valid, intact, and operational.
  final ErrorInfo? transientErrorInfo;

  const FormDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

  @override
  ErrorInfo? get errorInfo => transientErrorInfo;

  /// Quick check if the fresh state carries a transient operation error.
  bool get hasTransientError => transientErrorInfo != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormDataStateLoadedFresh &&
              runtimeType == other.runtimeType &&
              transientErrorInfo == other.transientErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, transientErrorInfo);

  @override
  String toBriefInfo() =>
      "loadedFresh(${transientErrorInfo == null ? '' : 'transientErr'})";

  @override
  String toString() =>
      'FormDataState.loadedFresh(transientError: $transientErrorInfo)';
}

/// Form data is loaded in RAM but marked stale due to background refetches, host data refreshes, or external events.
final class FormDataStateLoadedStale extends FormDataStateLoaded {
  final FormLoadedStateStaleReason reason;

  const FormDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven stale state.
  const FormDataStateLoadedStale.event({
    FormLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = const FormLoadedStateStaleReasonEvent();

  /// Factory constructor for host-data-refreshed stale state.
  FormDataStateLoadedStale.hostDataRefreshed({
    FormLoadedStateStaleReasonFailed? retainedFailureReason,
  }) : reason = FormLoadedStateStaleReasonHostDataRefreshed(
    retainedFailureReason: retainedFailureReason,
  );

  /// Factory constructor for query/reload-failure stale state.
  FormDataStateLoadedStale.failed({
    required ErrorInfo errorInfo,
  }) : reason = FormLoadedStateStaleReasonFailed(
    errorInfo: errorInfo,
  );

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [ErrorInfo] from the active reason or retained failure payload.
  @override
  ErrorInfo? get errorInfo => reason.errorInfo;

  /// Resolves the underlying failure reason if this stale state directly failed or carries a retained failure.
  FormLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      reason.underlyingFailureReason;

  /// Quick check whether this stale state carries any historical or active failure.
  bool get hasFailure => underlyingFailureReason != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormDataStateLoadedStale &&
              runtimeType == other.runtimeType &&
              reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "loadedStale(${reason.toBriefInfo()})";

  @override
  String toString() => 'FormDataState.loadedStale(reason: $reason)';
}

// =============================================================================
// PENDING REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind a [FormDataStatePending].
sealed class FormPendingReason {
  const FormPendingReason();

  /// Quick check whether this pending state was caused by a loading or setup failure.
  bool get isFailed => this is FormPendingReasonFailed;

  /// Quick check whether this pending state is uninitialized / initial cold loading.
  bool get isInitial => this is FormPendingReasonInitial;

  /// Quick check whether this pending state was triggered by a host data refresh or shift.
  bool get isHostDataRefreshed => this is FormPendingReasonHostDataRefreshed;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  ErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the pending reason hierarchy.
  FormPendingReasonFailed? get underlyingFailureReason =>
      switch (this) {
        FormPendingReasonFailed failure => failure,
        FormPendingReasonHostDataRefreshed(:final retainedFailureReason) =>
        retainedFailureReason,
        _ => null,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience factory for initial pending state.
  static const FormPendingReason initial = FormPendingReasonInitial();

  /// Convenience factory for failed pending state.
  static FormPendingReason failed({
    required ErrorInfo errorInfo,
  }) =>
      FormPendingReasonFailed(errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Initial cold baseline loading (First-time loading, no errors encountered yet).
final class FormPendingReasonInitial extends FormPendingReason {
  const FormPendingReasonInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FormPendingReasonInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "initial()";

  @override
  String toString() => 'FormPendingReason.initial';
}

/// Form dataset was evicted and entered pending state because the owning host data (Block item or Task initData) was refreshed or shifted.
final class FormPendingReasonHostDataRefreshed extends FormPendingReason {
  /// Retained failure state from earlier reload attempts (if any).
  final FormPendingReasonFailed? retainedFailureReason;

  const FormPendingReasonHostDataRefreshed({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormPendingReasonHostDataRefreshed &&
              runtimeType == other.runtimeType &&
              retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "hostDataRefreshed(${retainedFailureReason == null
          ? ''
          : 'retainedErr'})";

  @override
  String toString() =>
      'FormPendingReason.hostDataRefreshed(retainedFailureReason: $retainedFailureReason)';
}

/// Form loading failure where no prior form dataset exists.
final class FormPendingReasonFailed extends FormPendingReason {
  /// Structured diagnostic details regarding the failed loading attempt.
  @override
  final ErrorInfo errorInfo;

  const FormPendingReasonFailed({
    required this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormPendingReasonFailed &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "failed(err)";

  @override
  String toString() => 'FormPendingReason.failed(errorInfo: $errorInfo)';
}

// =============================================================================
// LOADED STALE REASONS HIERARCHY
// =============================================================================

/// Sealed hierarchy representing the specific rationale behind marking a loaded form dataset as stale.
sealed class FormLoadedStateStaleReason {
  const FormLoadedStateStaleReason();

  /// Quick check whether data became stale due to an incoming domain event / notification.
  bool get isEvent => this is FormLoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background reload or sync attempt failed.
  bool get isFailed => this is FormLoadedStateStaleReasonFailed;

  /// Quick check whether data is stale because its owning host data was refreshed.
  bool get isHostDataRefreshed =>
      this is FormLoadedStateStaleReasonHostDataRefreshed;

  /// Returns the active error payload if this is a failed state,
  /// or the preserved error payload from the retained failure if applicable.
  ErrorInfo? get errorInfo => underlyingFailureReason?.errorInfo;

  /// Resolves the underlying failure reason across the stale reason hierarchy.
  FormLoadedStateStaleReasonFailed? get underlyingFailureReason =>
      switch (this) {
        FormLoadedStateStaleReasonFailed failure => failure,
        FormLoadedStateStaleReasonEvent(:final retainedFailureReason) =>
        retainedFailureReason,
        FormLoadedStateStaleReasonHostDataRefreshed(
            :final retainedFailureReason
        ) =>
        retainedFailureReason,
      };

  /// Returns true if this reason either represents a failure or carries a preserved previous failure.
  bool get hasFailureHistory => underlyingFailureReason != null;

  /// Convenience constant for event-induced stale reason without previous failure.
  static const FormLoadedStateStaleReason event =
  FormLoadedStateStaleReasonEvent();

  /// Convenience constant for host-data-refreshed stale reason without previous failure.
  static const FormLoadedStateStaleReason hostDataRefreshed =
  FormLoadedStateStaleReasonHostDataRefreshed();

  /// Convenience factory for query/reload-failure stale reason.
  static FormLoadedStateStaleReason failed({
    required ErrorInfo errorInfo,
  }) =>
      FormLoadedStateStaleReasonFailed(
        errorInfo: errorInfo,
      );

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Form dataset is marked stale due to an external mutation event or sync trigger.
final class FormLoadedStateStaleReasonEvent extends FormLoadedStateStaleReason {
  /// Retained failure state from earlier reload attempts (if any).
  final FormLoadedStateStaleReasonFailed? retainedFailureReason;

  const FormLoadedStateStaleReasonEvent({this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormLoadedStateStaleReasonEvent &&
              runtimeType == other.runtimeType &&
              retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "event(${retainedFailureReason == null ? '' : 'retainedErr'})";

  @override
  String toString() =>
      'FormLoadedStateStaleReason.event(retainedFailureReason: $retainedFailureReason)';
}

/// Form dataset is marked stale because the corresponding owning Host data (Block item or Task/Stage initData) was refreshed.
///
/// ### Architectural Context:
/// This reason applies generically across different FormHost types:
/// * **In a Block (BlockFormModel)**: Triggered when the parent [Block]'s active `currentItem`
///   is re-queried, selected anew, or updated, rendering the current in-memory form fields
///   outdated relative to the new `ITEM_DETAIL`.
/// * **In a Task or Stage (TaskFormModel / StageFormModel)**: Triggered when the owning
///   [Task] or [Stage] successfully reloads or shifts its baseline `INIT_DATA`
///   (e.g., via a manual "Reload Init Data" action), meaning previous user inputs
///   or mapped values in the form need to be invalidated or re-synchronized.
final class FormLoadedStateStaleReasonHostDataRefreshed
    extends FormLoadedStateStaleReason {
  /// Retained failure state from earlier reload attempts (if any).
  final FormLoadedStateStaleReasonFailed? retainedFailureReason;

  const FormLoadedStateStaleReasonHostDataRefreshed(
      {this.retainedFailureReason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormLoadedStateStaleReasonHostDataRefreshed &&
              runtimeType == other.runtimeType &&
              retainedFailureReason == other.retainedFailureReason;

  @override
  int get hashCode => Object.hash(runtimeType, retainedFailureReason);

  @override
  String toBriefInfo() =>
      "hostDataRefreshed(${retainedFailureReason == null
          ? ''
          : 'retainedErr'})";

  @override
  String toString() =>
      'FormLoadedStateStaleReason.hostDataRefreshed(retainedFailureReason: $retainedFailureReason)';
}

/// Form dataset is marked stale because a subsequent background reload or sync attempt failed.
final class FormLoadedStateStaleReasonFailed
    extends FormLoadedStateStaleReason {
  /// Structured diagnostic details regarding the failed reload attempt.
  @override
  final ErrorInfo errorInfo;

  const FormLoadedStateStaleReasonFailed({
    required this.errorInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormLoadedStateStaleReasonFailed &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "failed(err)";

  @override
  String toString() =>
      'FormLoadedStateStaleReason.failed(errorInfo: $errorInfo)';
}
