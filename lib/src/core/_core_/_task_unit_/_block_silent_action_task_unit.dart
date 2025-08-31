part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockSilentActionAnnotation()
class _BlockSilentActionTaskUnit
    extends _ResultedSTaskUnit<BlockSilentActionResult> {
  final XBlock xBlock;
  final BlockSilentAction action;

  _BlockSilentActionTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockSilentAction,
          taskResult: BlockSilentActionResult(),
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
