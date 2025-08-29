part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockItemDeletionTaskUnit
    extends _ResultedSTaskUnit<BlockItemDeletionResult> {
  XBlock xBlock;
  final Object item;

  _BlockItemDeletionTaskUnit({
    required this.xBlock,
    required this.item,
    required super.taskResult,
  }) : super(taskType: TaskType.blockDeleteItem);

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
