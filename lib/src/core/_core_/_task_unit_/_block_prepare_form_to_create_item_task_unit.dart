part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockPrepareFormToCreateItemTaskUnit extends _TaskUnit {
  _QBlock xBlock;
  ExtraFormInput? extraFormInput;
  Function()? navigate;
  final bool initDirty;

  _BlockPrepareFormToCreateItemTaskUnit({
    required this.xBlock,
    required this.initDirty,
    required this.extraFormInput,
    required this.navigate,
  }) : super(taskType: TaskType.blockPrepareToCreateItem);

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
