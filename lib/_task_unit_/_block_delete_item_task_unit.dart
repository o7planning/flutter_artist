part of '../flutter_artist.dart';

class _BlockDeleteItemTaskUnit extends _TaskUnit {
  _XBlock xBlock;
  Object item;

  _BlockDeleteItemTaskUnit({
    required this.xBlock,
    required this.item,
  });

  @override
  int get xShelfId => xBlock.xShelfId;

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
