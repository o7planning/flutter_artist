part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockDeleteItemsTaskUnit
    extends _ResultedTaskUnit<BlockItemsDeletionResult> {
  _QBlock xBlock;
  final List<Object> items;
  final bool stopIfError;

  _BlockDeleteItemsTaskUnit({
    required this.xBlock,
    required this.items,
    required super.taskResult,
    required this.stopIfError,
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
