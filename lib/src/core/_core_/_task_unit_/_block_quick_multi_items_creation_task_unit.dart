part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickCreateMultiItemsActionAnnotation()
class _BlockQuickMultiItemsCreationTaskUnit
    extends _ResultedTaskUnit<BlockQuickMultiItemsCreationResult> {
  XBlock xBlock;

  BlockQuickMultiItemsCreationAction action;

  _BlockQuickMultiItemsCreationTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickCreateMultiItems,
          taskResult: BlockQuickMultiItemsCreationResult(),
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
