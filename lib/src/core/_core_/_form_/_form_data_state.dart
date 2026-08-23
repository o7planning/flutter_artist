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

  /// Indicates whether the form metadata and item details are fully loaded and operational.
  bool get isLoaded => this is FormDataStateLoaded;

  /// Quick accessor to diagnostic error payload if in [FormDataStateFatalError] or [FormDataStateLoaded] carrying transient error.
  ErrorInfo? get errorInfo =>
      switch (this) {
        FormDataStateFatalError(:final errorInfo) => errorInfo,
        FormDataStateLoaded(:final transientErrorInfo) => transientErrorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
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
  String toString() => 'FormDataState.none';
}

/// Form has an assigned target item or creation context, but is either hidden or bootstrapping.
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
  String toString() => 'FormDataState.fatalError(errorInfo: $errorInfo)';
}

/// Form metadata and item details are loaded successfully and ready for user interactions.
final class FormDataStateLoaded extends FormDataState {
  /// Structured diagnostic details for errors occurring during non-destructive,
  /// secondary field operations (e.g., failed cascading dropdowns or async field validation)
  /// while the overall form remains active and operational.
  final ErrorInfo? transientErrorInfo;

  const FormDataStateLoaded({this.transientErrorInfo});

  @override
  String get name => "loaded";

  /// Quick check if the loaded state carries a transient field operation error.
  bool get hasTransientError => transientErrorInfo != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormDataStateLoaded &&
              runtimeType == other.runtimeType &&
              transientErrorInfo == other.transientErrorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, transientErrorInfo);

  @override
  String toString() =>
      'FormDataState.loaded(transientErrorInfo: $transientErrorInfo)';
}
