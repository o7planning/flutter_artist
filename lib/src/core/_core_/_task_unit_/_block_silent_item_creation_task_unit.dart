part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockSilentItemCreationActionAnnotation()
class _BlockSilentItemCreationTaskUnit
    extends _ResultedSTaskUnit<BlockSilentItemCreationResult> {
  XBlock xBlock;
  BlockSilentItemCreationAction action;

  _BlockSilentItemCreationTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
    taskType: TaskType.blockSilentCreateItem,
    taskResult: BlockSilentItemCreationResult(),
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
