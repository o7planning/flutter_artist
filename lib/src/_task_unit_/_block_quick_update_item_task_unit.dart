part of '../_fa_core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickUpdateItemActionAnnotation()
class _BlockQuickUpdateItemTaskUnit
    extends _ResultedTaskUnit<BlockQuickUpdateItemResult> {
  _XBlock xBlock;
  BlockQuickUpdateItemAction action;

  _BlockQuickUpdateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickUpdateItem,
          taskResult: BlockQuickUpdateItemResult(),
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
