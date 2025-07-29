part of '../_fa_core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickActionAnnotation()
class _BlockQuickActionTaskUnit<DATA extends Object>
    extends _ResultedTaskUnit<BlockQuickActionResult> {
  final _XBlock xBlock;
  final BlockQuickAction action;

  _BlockQuickActionTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickAction,
          taskResult: BlockQuickActionResult(),
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
