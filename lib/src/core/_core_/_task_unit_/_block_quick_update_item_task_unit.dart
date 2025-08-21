part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickUpdateItemActionAnnotation()
class _BlockQuickUpdateItemTaskUnit
    extends _ResultedTaskUnit<BlockQuickItemUpdateResult> {
  XBlock xBlock;
  BlockQuickItemUpdateAction action;

  _BlockQuickUpdateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickUpdateItem,
          taskResult: BlockQuickItemUpdateResult(),
        );

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
