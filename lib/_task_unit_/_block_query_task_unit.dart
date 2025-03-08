part of '../flutter_artist.dart';

class _BlockQueryTaskUnit extends _TaskUnit {
  _XBlock xBlock;

  _BlockQueryTaskUnit({
    required this.xBlock,
  }) {
    // xBlock.setForceQuery();
  }

  @override
  Shelf get shelf =>xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }


}
