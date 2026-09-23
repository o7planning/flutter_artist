part of '../core.dart';

/// Root sealed state container for Task lifecycle readiness.
@immutable
sealed class TaskDataState {
  const TaskDataState();

  String get name;

  bool get isPending => this is TaskDataStatePending;
  bool get isLoaded => this is TaskDataStateLoaded;
  bool get isFresh => this is TaskDataStateLoadedFresh;
  bool get isStale => this is TaskDataStateLoadedStale;

  TaskErrorInfo? get errorInfo => switch (this) {
    TaskDataStatePending(:final errorInfo) => errorInfo,
    TaskDataStateLoadedStale(:final errorInfo) => errorInfo,
    _ => null,
  };

  bool get hasError => errorInfo != null;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Task has never run or was invalidated and requires execution.
final class TaskDataStatePending extends TaskDataState {
  @override
  final TaskErrorInfo? errorInfo;

  const TaskDataStatePending({this.errorInfo});

  @override
  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskDataStatePending &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "pending(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'TaskDataState.pending(errorInfo: $errorInfo)';
}

/// Base sealed class for states where Task output data is held in memory.
sealed class TaskDataStateLoaded extends TaskDataState {
  const TaskDataStateLoaded();
}

/// Task has executed successfully and output data is current.
final class TaskDataStateLoadedFresh extends TaskDataStateLoaded {
  const TaskDataStateLoadedFresh();

  @override
  String get name => "loaded + fresh";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskDataStateLoadedFresh;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "fresh()";

  @override
  String toString() => 'TaskDataState.loadedFresh()';
}

/// Task holds previous result, but needs re-execution.
final class TaskDataStateLoadedStale extends TaskDataStateLoaded {
  @override
  final TaskErrorInfo? errorInfo;

  const TaskDataStateLoadedStale({this.errorInfo});

  @override
  String get name => "loaded + stale";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskDataStateLoadedStale &&
              runtimeType == other.runtimeType &&
              errorInfo == other.errorInfo;

  @override
  int get hashCode => Object.hash(runtimeType, errorInfo);

  @override
  String toBriefInfo() => "stale(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'TaskDataState.loadedStale(errorInfo: $errorInfo)';
}