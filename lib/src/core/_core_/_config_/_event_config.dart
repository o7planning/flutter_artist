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
