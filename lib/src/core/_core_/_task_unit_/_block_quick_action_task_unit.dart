part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickActionAnnotation()
class _BlockQuickActionTaskUnit
    extends _ResultedTaskUnit<BlockQuickActionResult> {
  final _QBlock xBlock;
  final BlockQuickAction action;

  _BlockQuickActionTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickAction,
          taskResult: BlockQuickActionResult(),
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
