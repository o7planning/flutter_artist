part of '../flutter_artist.dart';

class _BlockClearCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _XBlock xBlock;

  _BlockClearCurrentTaskUnit({
    required this.xBlock,
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
