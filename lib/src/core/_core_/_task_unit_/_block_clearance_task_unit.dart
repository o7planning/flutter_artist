part of '../core.dart';

@_TaskUnitClassAnnotation()
class _BlockClearanceTaskUnit extends _ResultedTaskUnit<BlockClearanceResult> {
  final XBlock xBlock;

  _BlockClearanceTaskUnit({
    required this.xBlock,
  }) : super(
          taskType: TaskType.blockClearance,
          taskResult: BlockClearanceResult(
            precheck: null,
          ),
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
