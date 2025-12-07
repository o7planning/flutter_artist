part of '../core.dart';

enum SrcType {
  block,
  scalar,
  activity;
}

enum EventType {
  creation,
  update,
  deletion,
  unknown;
}

class Evt extends Equatable {
  final SrcType srcType;
  final String srcName;

  const Evt.insideBlock(this.srcName) : srcType = SrcType.block;

  const Evt.insideScalar(this.srcName) : srcType = SrcType.scalar;

  // IMPORTANT:
  @override
  List<Object?> get props => [srcType, srcName];

  @override
  String toString() {
    return "Evt($srcType, $srcName)";
  }
}

class Event extends Equatable {
  final Type dataType;

  const Event(this.dataType);

  // IMPORTANT:
  @override
  List<Object?> get props => [dataType];

  @override
  String toString() {
    return "Event($dataType)";
  }
}
