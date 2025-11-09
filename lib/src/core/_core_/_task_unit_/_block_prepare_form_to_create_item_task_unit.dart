part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockPrepareFormToCreateItemTaskUnit extends _STaskUnit {
  XBlock xBlock;
  FormInput? formInput;
  Function()? navigate;
  final bool initDirty;

  _BlockPrepareFormToCreateItemTaskUnit({
    required this.xBlock,
    required this.initDirty,
    required this.formInput,
    required this.navigate,
  }) : super(taskType: TaskType.blockPrepareToCreateItem);

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
