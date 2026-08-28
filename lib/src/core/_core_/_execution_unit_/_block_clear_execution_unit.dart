part of '../core.dart';

@_ExecutionUnitClassAnnotation()
class _BlockClearExecutionUnit extends _ResultedSExecutionUnit<BlockClearResult> {
  final XBlock xBlock;

  _BlockClearExecutionUnit({
    required this.xBlock,
  }) : super(
          executionUnitType: ExecutionUnitType.blockClear,
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
