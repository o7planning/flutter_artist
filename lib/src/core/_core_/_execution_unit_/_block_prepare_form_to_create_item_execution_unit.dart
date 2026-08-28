part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockPrepareFormToCreateItemExecutionUnit extends _SExecutionUnit {
  XBlock xBlock;
  FormInput? formInput;
  final bool initDirty;

  _BlockPrepareFormToCreateItemExecutionUnit({
    required this.xBlock,
    required this.initDirty,
    required this.formInput,
  }) : super(executionUnitType: ExecutionUnitType.blockPrepareToCreateItem);

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
