part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockClearCurrentAnnotation()
class _BlockClearCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _QBlock xBlock;

  _BlockClearCurrentTaskUnit({
    required this.xBlock,
  }) : super(taskType: TaskType.blockClearCurrentItem);

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
