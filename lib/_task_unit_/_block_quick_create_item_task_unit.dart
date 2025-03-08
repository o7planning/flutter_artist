part of '../flutter_artist.dart';

class _BlockQuickCreateItemTaskUnit extends _TaskUnit {
  _XBlock xBlock;
  QuickCreateItemAction action;

  _BlockQuickCreateItemTaskUnit({
    required this.xBlock,
    required this.action,
  });


  @override
  Shelf get shelf =>xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
