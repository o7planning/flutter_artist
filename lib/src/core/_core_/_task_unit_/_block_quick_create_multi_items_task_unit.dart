part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickCreateMultiItemsActionAnnotation()
class _BlockQuickCreateMultiItemsTaskUnit
    extends _ResultedTaskUnit<BlockQuickMultiItemsCreationResult> {
  _QBlock xBlock;

  BlockQuickCreateMultiItemsAction action;

  _BlockQuickCreateMultiItemsTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickCreateMultiItems,
          taskResult: BlockQuickMultiItemsCreationResult(),
        );

  @override
  _QShelf get xShelf => xBlock.xShelf;

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
