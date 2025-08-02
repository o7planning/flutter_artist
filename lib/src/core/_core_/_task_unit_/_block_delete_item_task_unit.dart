part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockDeleteItemTaskUnit extends _ResultedTaskUnit<BlockItemDeletionResult> {
  _XBlock xBlock;
  final Object item;

  _BlockDeleteItemTaskUnit({
    required this.xBlock,
    required this.item,
    required super.taskResult,
  }) : super(taskType: TaskType.blockDeleteItem);

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
