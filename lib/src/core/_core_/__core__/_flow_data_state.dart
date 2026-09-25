part of '../core.dart';

/// Root sealed state container for overall Flow lifecycle readiness.
@immutable
sealed class FlowDataState<STAGE_ENUM extends Enum> {
  const FlowDataState();

  String get name;

  bool get isNone => this is FlowDataStateNone;

  bool get isPending => this is FlowDataStatePending;

  bool get isCompleted => this is FlowDataStateCompleted;

  bool get isAborted => this is FlowDataStateAborted;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  String toBriefInfo();
}

/// Flow has not initialized its prerequisite FlowContextData.
final class FlowDataStateNone<STAGE_ENUM extends Enum>
    extends FlowDataState<STAGE_ENUM> {
  const FlowDataStateNone();

  @override
  String get name => "none";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FlowDataStateNone<STAGE_ENUM>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'FlowDataState.none()';
}

/// Flow is actively progressing, currently stationed at [currentStageId].
final class FlowDataStatePending<STAGE_ENUM extends Enum>
    extends FlowDataState<STAGE_ENUM> {
  final STAGE_ENUM currentStageId;

  const FlowDataStatePending({required this.currentStageId});

  @override
  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowDataStatePending<STAGE_ENUM> &&
          runtimeType == other.runtimeType &&
          currentStageId == other.currentStageId;

  @override
  int get hashCode => Object.hash(runtimeType, currentStageId);

  @override
  String toBriefInfo() => "pending(${currentStageId.name})";

  @override
  String toString() => 'FlowDataState.pending(currentStageId: $currentStageId)';
}

/// Flow has completed all its stages successfully.
final class FlowDataStateCompleted<STAGE_ENUM extends Enum>
    extends FlowDataState<STAGE_ENUM> {
  const FlowDataStateCompleted();

  @override
  String get name => "completed";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FlowDataStateCompleted<STAGE_ENUM>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "completed()";

  @override
  String toString() => 'FlowDataState.completed()';
}

/// Flow was stopped, cancelled, or aborted before reaching completion.
final class FlowDataStateAborted<STAGE_ENUM extends Enum>
    extends FlowDataState<STAGE_ENUM> {
  final String? reason;

  const FlowDataStateAborted({this.reason});

  @override
  String get name => "aborted";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowDataStateAborted<STAGE_ENUM> &&
          runtimeType == other.runtimeType &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "aborted(${reason ?? ''})";

  @override
  String toString() => 'FlowDataState.aborted(reason: $reason)';
}
