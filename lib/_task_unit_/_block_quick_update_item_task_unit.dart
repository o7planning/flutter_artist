part of '../flutter_artist.dart';

class _BlockQuickUpdateItemTaskUnit extends _TaskUnit {
  _XBlock xBlock;
  QuickUpdateItemAction action;

  _BlockQuickUpdateItemTaskUnit({
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
