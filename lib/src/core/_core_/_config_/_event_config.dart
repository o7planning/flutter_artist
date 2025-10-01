part of '../core.dart';

enum SrcType {
  block,
  scalar,
  activity;
}

class Evt {
  final SrcType srcType;
  final String srcName;

  Evt.insideBlock(this.srcName) : srcType = SrcType.block;

  Evt.insideScalar(this.srcName) : srcType = SrcType.scalar;
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
