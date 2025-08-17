part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickChildBlockItemsActionAnnotation()
class _BlockQuickChildBlockItemsTaskUnit<
    ITEM extends Object, //
    ITEM_DETAIL extends Object> extends _TaskUnit {
  _XBlock xBlock;
  BlockQuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action;

  _BlockQuickChildBlockItemsTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(taskType: TaskType.blockQuickChildBlockItems);

  @override
  _XShelf get xShelf => xBlock.xShelf;

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
