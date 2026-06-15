part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickMultiItemCreationActionAnnotation()
class _BlockQuickMultiItemCreationTaskUnit
    extends _ResultedSTaskUnit<BlockQuickMultiItemCreationResult> {
  XBlock xBlock;

  BlockQuickMultiItemCreationAction action;

  _BlockQuickMultiItemCreationTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickMultiItemCreation,
          taskResult: BlockQuickMultiItemCreationResult(),
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
