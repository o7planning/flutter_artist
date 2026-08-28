part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockClearCurrentItemAnnotation()
class _BlockClearCurrentExecutionUnit<ITEM extends Identifiable> extends _SExecutionUnit {
  final XBlock xBlock;

  _BlockClearCurrentExecutionUnit({
    required this.xBlock,
  }) : super(executionUnitType: ExecutionUnitType.blockClearCurrentItem);

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
