part of '../flutter_artist.dart';

class _BlockQuickCreateMultiItemsTaskUnit extends _TaskUnit {
  _XBlock xBlock;

  QuickCreateMultiItemsAction action;

  _BlockQuickCreateMultiItemsTaskUnit({
    required this.xBlock,
    required this.action,
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
