part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickItemCreationActionAnnotation()
class _BlockQuickItemCreationTaskUnit
    extends _ResultedTaskUnit<BlockQuickItemCreationResult> {
  XBlock xBlock;
  BlockQuickItemCreationAction action;

  _BlockQuickItemCreationTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickCreateItem,
          taskResult: BlockQuickItemCreationResult(),
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
