part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockSilentUpdateItemActionAnnotation()
class _BlockSilentUpdateItemTaskUnit
    extends _ResultedTaskUnit<BlockSilentItemUpdateResult> {
  XBlock xBlock;
  BlockSilentItemUpdateAction action;

  _BlockSilentUpdateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockSilentUpdateItem,
          taskResult: BlockSilentItemUpdateResult(),
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
