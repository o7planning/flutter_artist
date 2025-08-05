part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickCreateItemActionAnnotation()
class _BlockQuickCreateItemTaskUnit
    extends _ResultedTaskUnit<BlockQuickItemCreationResult> {
  _XBlock xBlock;
  BlockQuickCreateItemAction action;

  _BlockQuickCreateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickCreateItem,
          taskResult: BlockQuickItemCreationResult(),
        );

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
