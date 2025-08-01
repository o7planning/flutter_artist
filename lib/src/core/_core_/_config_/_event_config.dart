part of '../core.dart';

enum SrcType {
  block,
  scalar,
  activity;
}

enum EvtType {
  creation,
  update,
  deletion;
}

class Evt {
  final SrcType srcType;
  final EvtType? evtType;
  final String srcName;

  Evt.blockC(this.srcName)
      : evtType = EvtType.creation,
        srcType = SrcType.block;

  Evt.blockU(this.srcName)
      : evtType = EvtType.update,
        srcType = SrcType.block;

  Evt.blockD(this.srcName)
      : evtType = EvtType.deletion,
        srcType = SrcType.block;

  Evt.blockCUD(this.srcName)
      : evtType = null,
        srcType = SrcType.block;

  Evt.scalarU(this.srcName)
      : evtType = EvtType.update,
        srcType = SrcType.scalar;
}
