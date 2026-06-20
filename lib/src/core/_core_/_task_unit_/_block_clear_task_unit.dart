part of '../core.dart';

@_TaskUnitClassAnnotation()
class _BlockClearTaskUnit extends _ResultedSTaskUnit<BlockClearResult> {
  final XBlock xBlock;

  _BlockClearTaskUnit({
    required this.xBlock,
  }) : super(
    taskType: TaskType.blockClear,
    taskResult: BlockClearResult(
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
