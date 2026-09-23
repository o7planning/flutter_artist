part of '../core.dart';

/// Root sealed state container for individual Stage lifecycle within a Flow.
@immutable
sealed class StageDataState {
  const StageDataState();

  String get name;

  bool get isNone => this is StageDataStateNone;
  bool get isPending => this is StageDataStatePending;
  bool get isLoaded => this is StageDataStateLoaded;
  bool get isFresh => this is StageDataStateLoadedFresh;
  bool get isStale => this is StageDataStateLoadedStale;

  StageErrorInfo? get errorInfo => switch (this) {
        StageDataStatePending(:final errorInfo) => errorInfo,
        StageDataStateLoadedStale(:final errorInfo) => errorInfo,
        _ => null,
      };

  bool get hasError => errorInfo != null;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Stage has not been reached yet in the workflow.
final class StageDataStateNone extends StageDataState {
  const StageDataStateNone();

  @override
  String get name => "none";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageDataStateNone;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'StageDataState.none()';
}

/// Stage is currently focused, awaiting input or step submission.
final class StageDataStatePending extends StageDataState {
  @override
  final StageErrorInfo? errorInfo;

  const StageDataStatePending({this.errorInfo});

  @override
  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StageDataStatePending &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "pending(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'StageDataState.pending(errorInfo: $errorInfo)';
}

/// Base sealed class for states where Stage data has been submitted and confirmed.
sealed class StageDataStateLoaded extends StageDataState {
  const StageDataStateLoaded();
}

/// Stage was submitted successfully and its step data is intact.
final class StageDataStateLoadedFresh extends StageDataStateLoaded {
  const StageDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "fresh()";

  @override
  String toString() => 'StageDataState.loadedFresh()';
}

/// Stage data was confirmed previously, but predecessor mutations made it outdated.
final class StageDataStateLoadedStale extends StageDataStateLoaded {
  @override
  final StageErrorInfo? errorInfo;

  const StageDataStateLoadedStale({this.errorInfo});

  @override
  String get name => "loaded + stale";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StageDataStateLoadedStale &&
          runtimeType == other.runtimeType &&
          errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "stale(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'StageDataState.loadedStale(errorInfo: $errorInfo)';
}
