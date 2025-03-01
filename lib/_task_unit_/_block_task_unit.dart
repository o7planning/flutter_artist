part of '../flutter_artist.dart';

class _BlockQueryTaskUnit extends _TaskUnit {
  _XBlock xBlock;

  _BlockQueryTaskUnit({
    required this.xBlock,
  }) {
    xBlock.setForceQuery();
  }
}
