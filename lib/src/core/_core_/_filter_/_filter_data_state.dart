part of '../core.dart';

/// Sealed hierarchy representing the data lifecycle states of a [FilterModel].
@immutable
sealed class FilterDataState {
  const FilterDataState();

  String get name;

  /// Indicates whether the filter model is currently initializing or loading options.
  bool get isPending => this is FilterDataStatePending;

  /// Indicates whether the filter model encountered an initialization or validation failure.
  bool get isError => this is FilterDataStateError;

  /// Indicates whether the filter criteria and options are fully loaded and operational.
  bool get isLoaded => this is FilterDataStateLoaded;

  /// Quick accessor to diagnostic error payload if in [FilterDataStateError], otherwise null.
  ErrorInfo? get errorInfo => switch (this) {
        FilterDataStateError(:final errorInfo) => errorInfo,
        _ => null,
      };

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Filter model is initializing, evaluating conditions, or loading option datasets.
final class FilterDataStatePending extends FilterDataState {
  const FilterDataStatePending();

  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FilterDataStatePending;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'FilterDataState.pending';
}

/// Filter model encountered an operational error with guaranteed non-null [ErrorInfo].
final class FilterDataStateError extends FilterDataState {
  /// Diagnostic error details regarding the filter initialization or validation failure.
  final ErrorInfo errorInfo;

  const FilterDataStateError({required this.errorInfo});

  String get name => "error";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterDataStateError &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toString() => 'FilterDataState.error(errorInfo: $errorInfo)';
}

/// Filter model options and criteria structures are ready for interaction.
final class FilterDataStateLoaded extends FilterDataState {
  const FilterDataStateLoaded();

  String get name => "loaded";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FilterDataStateLoaded;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'FilterDataState.loaded';
}
