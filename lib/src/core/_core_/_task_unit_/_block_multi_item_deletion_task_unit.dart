part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockMultiItemDeletionTaskUnit<ID extends Comparable,
        ITEM extends Identifiable<ID>>
    extends _ResultedSTaskUnit<BlockItemsDeletionResult> {
  XBlock xBlock;
  final List<ITEM> items;
  final bool stopIfError;

  _BlockMultiItemDeletionTaskUnit({
    required this.xBlock,
    required this.items,
    required super.taskResult,
    required this.stopIfError,
  }) : super(taskType: TaskType.blockDeleteItems);

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
