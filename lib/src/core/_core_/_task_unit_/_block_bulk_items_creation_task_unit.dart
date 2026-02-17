part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockBlockBulkItemsCreationActionAnnotation()
class _BlockBulkItemsCreationTaskUnit
    extends _ResultedSTaskUnit<BlockBulkItemsCreationResult> {
  XBlock xBlock;

  BlockBulkItemsCreationAction action;

  _BlockBulkItemsCreationTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockBulkItemsCreation,
          taskResult: BlockBulkItemsCreationResult(),
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
