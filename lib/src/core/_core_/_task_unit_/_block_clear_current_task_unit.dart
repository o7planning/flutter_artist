part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockClearCurrentAnnotation()
class _BlockClearCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final XBlock xBlock;

  _BlockClearCurrentTaskUnit({
    required this.xBlock,
  }) : super(taskType: TaskType.blockClearCurrentItem);

  @override
  XShelf get xShelf => xBlock.xShelf;

  @override
  int get xShelfId => xBlock.xShelfId;

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  Block get owner => xBlock.block;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
