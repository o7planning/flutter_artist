part of '../core.dart';

/// Sealed hierarchy representing the discrete lifecycle states of a [FormModel].
@immutable
sealed class FormDataState {
  const FormDataState();

  String get name;

  /// Indicates whether the form has no active target item context (dormant).
  bool get isNone => this is FormDataStateNone;

  /// Indicates whether the form has a target item but is deferred or actively bootstrapping.
  bool get isPending => this is FormDataStatePending;

  /// Indicates whether bootstrapping failed, locking the form from interaction.
  bool get isFatalError => this is FormDataStateFatalError;

  /// Indicates whether the form metadata and item details are loaded in RAM (either fresh or stale).
  bool get isLoaded => this is FormDataStateLoaded;

  /// Indicates whether the active form data in RAM is completely up-to-date.
  bool get isFresh => this is FormDataStateLoadedFresh;

  /// Indicates whether the active form data in RAM is outdated due to background refresh, parent block events, etc.
  bool get isStale => this is FormDataStateLoadedStale;

  /// Quick accessor to diagnostic error payload across all error-carrying states.
  ErrorInfo? get errorInfo => switch (this) {
        FormDataStateFatalError(:final errorInfo) => errorInfo,
        FormDataStateLoadedFresh(:final transientErrorInfo) =>
          transientErrorInfo,
        FormDataStateLoadedStale(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Form has no target item selected in the parent Block and remains dormant.
final class FormDataStateNone extends FormDataState {
  const FormDataStateNone();

  @override
  String get name => "none";

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

/// Form has an assigned target item or creation context, but is either hidden or bootstrapping cold.
final class FormDataStatePending extends FormDataState {
  const FormDataStatePending();

  @override
  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FormDataStatePending;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "pending()";

  @override
  String toString() => 'FormDataState.pending';
}

/// Form bootstrapping encountered an unrecoverable failure with guaranteed non-null [ErrorInfo].
final class FormDataStateFatalError extends FormDataState {
  /// Diagnostic error details regarding metadata loading or item detail resolution.
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
  String toBriefInfo() => "fatalError(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'FormDataState.fatalError(errorInfo: $errorInfo)';
}

/// Base sealed class for states where form data is loaded and retained in RAM.
sealed class FormDataStateLoaded extends FormDataState {
  const FormDataStateLoaded();
}

/// Form data in RAM is fully fresh, synchronized, and ready for user interactions.
final class FormDataStateLoadedFresh extends FormDataStateLoaded {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary field operations (e.g., failed cascading dropdowns or async field validation)
  /// while the overall form remains active and operational.
  final ErrorInfo? transientErrorInfo;

  const FormDataStateLoadedFresh({this.transientErrorInfo});

  @override
  String get name => "loaded + fresh";

  /// Quick check if the fresh state carries a transient field operation error.
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
      "fresh(${transientErrorInfo == null ? '' : 'transientErr'})";

  @override
  String toString() =>
      'FormDataState.loadedFresh(transientErrorInfo: $transientErrorInfo)';
}

/// Form data is retained in RAM but marked stale due to external mutations,
/// parent Block item refreshes while the form was hidden, or background refetch failures.
final class FormDataStateLoadedStale extends FormDataStateLoaded {
  final FormLoadedStateStaleReason reason;

  const FormDataStateLoadedStale({required this.reason});

  /// Factory constructor for event-driven / item-refresh stale state.
  const FormDataStateLoadedStale.event()
      : reason = const FormLoadedStateStaleReasonEvent();

  /// Factory constructor for re-query failure stale state.
  FormDataStateLoadedStale.failed({required ErrorInfo errorInfo})
      : reason = FormLoadedStateStaleReasonFailed(errorInfo: errorInfo);

  @override
  String get name => "loaded + stale";

  /// Quick accessor extracting [ErrorInfo] if the stale reason was caused by a fetch failure.
  ErrorInfo? get errorInfo => reason.errorInfo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "stale(${reason.toBriefInfo()})";

  @override
  String toString() => 'FormDataState.loadedStale(reason: $reason)';
}

/// Sealed hierarchy representing the specific rationale behind marking loaded Form data as stale.
sealed class FormLoadedStateStaleReason {
  const FormLoadedStateStaleReason();

  /// Quick check whether data became stale due to an external mutation event.
  bool get isEvent => this is FormLoadedStateStaleReasonEvent;

  /// Quick check whether data is stale because a background reload or sync attempt failed.
  bool get isFailed => this is FormLoadedStateStaleReasonFailed;

  /// Quick check whether data is stale because its target/bound item in the parent Block was refreshed.
  bool get isItemRefreshed => this is FormLoadedStateStaleReasonItemRefreshed;

  /// Quick accessor to diagnostic error payload if available.
  ErrorInfo? get errorInfo => switch (this) {
        FormLoadedStateStaleReasonFailed(:final errorInfo) => errorInfo,
        _ => null,
      };

  /// Convenience constant for event-induced stale reason.
  static const FormLoadedStateStaleReason event =
      FormLoadedStateStaleReasonEvent();

  /// Convenience constant for item-refresh-induced stale reason.
  static const FormLoadedStateStaleReason itemRefreshed =
      FormLoadedStateStaleReasonItemRefreshed();

  /// Convenience factory for reload-failure stale reason.
  static FormLoadedStateStaleReason failed({required ErrorInfo errorInfo}) =>
      FormLoadedStateStaleReasonFailed(errorInfo: errorInfo);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Form data marked stale due to an external mutation or domain sync notification.
final class FormLoadedStateStaleReasonEvent extends FormLoadedStateStaleReason {
  const FormLoadedStateStaleReasonEvent();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FormLoadedStateStaleReasonEvent;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "event()";

  @override
  String toString() => 'FormLoadedStateStaleReason.event';
}

/// Form data marked stale because the corresponding target item in the parent Block was refreshed.
final class FormLoadedStateStaleReasonItemRefreshed
    extends FormLoadedStateStaleReason {
  const FormLoadedStateStaleReasonItemRefreshed();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormLoadedStateStaleReasonItemRefreshed;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "itemRefreshed()";

  @override
  String toString() => 'FormLoadedStateStaleReason.itemRefreshed';
}

/// Form data marked stale because a subsequent background reload or detail sync attempt failed.
final class FormLoadedStateStaleReasonFailed
    extends FormLoadedStateStaleReason {
  final ErrorInfo errorInfo;

  const FormLoadedStateStaleReasonFailed({required this.errorInfo});

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
