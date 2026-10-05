part of '../core.dart';

/// Root sealed state container for overall Prozess lifecycle readiness.
@immutable
sealed class ProzessDataState<STAGE_ENUM extends Enum> implements DataState {
  const ProzessDataState();

  String get name;

  bool get isNone => this is ProzessDataStateNone;

  bool get isPending => this is ProzessDataStatePending;

  bool get isCompleted => this is ProzessDataStateCompleted;

  bool get isAborted => this is ProzessDataStateAborted;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

/// Prozess has not initialized its prerequisite ProzessContextData.
final class ProzessDataStateNone<STAGE_ENUM extends Enum>
    extends ProzessDataState<STAGE_ENUM> {
  const ProzessDataStateNone();

  @override
  String get name => "none";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessDataStateNone<STAGE_ENUM>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'ProzessDataState.none()';
}

/// Prozess is actively progressing, currently stationed at [currentStageId].
final class ProzessDataStatePending<STAGE_ENUM extends Enum>
    extends ProzessDataState<STAGE_ENUM> {
  final STAGE_ENUM currentStageId;

  const ProzessDataStatePending({required this.currentStageId});

  @override
  String get name => "pending";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProzessDataStatePending<STAGE_ENUM> &&
              runtimeType == other.runtimeType &&
              currentStageId == other.currentStageId;

  @override
  int get hashCode => Object.hash(runtimeType, currentStageId);

  @override
  String toBriefInfo() => "pending(${currentStageId.name})";

  @override
  String toString() =>
      'ProzessDataState.pending(currentStageId: $currentStageId)';
}

/// Prozess has completed all its stages successfully.
final class ProzessDataStateCompleted<STAGE_ENUM extends Enum>
    extends ProzessDataState<STAGE_ENUM> {
  const ProzessDataStateCompleted();

  @override
  String get name => "completed";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProzessDataStateCompleted<STAGE_ENUM>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toBriefInfo() => "completed()";

  @override
  String toString() => 'ProzessDataState.completed()';
}

/// Prozess was stopped, cancelled, or aborted before reaching completion.
final class ProzessDataStateAborted<STAGE_ENUM extends Enum>
    extends ProzessDataState<STAGE_ENUM> {
  final String? reason;

  const ProzessDataStateAborted({this.reason});

  @override
  String get name => "aborted";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProzessDataStateAborted<STAGE_ENUM> &&
              runtimeType == other.runtimeType &&
              reason == other.reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toBriefInfo() => "aborted(${reason ?? ''})";

  @override
  String toString() => 'ProzessDataState.aborted(reason: $reason)';
}
