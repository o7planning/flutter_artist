part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockQueryAnnotation()
@_BlockQueryMorePageAnnotation()
@_BlockQueryNextPageAnnotation()
@_BlockQueryPreviousPageAnnotation()
@_BlockQueryAndPrepareToEditAnnotation()
@_BlockQueryAndPrepareToCreateAnnotation()
@Deprecated("Xoa di")
class _BlockQueryTaskUnitOLD extends _TaskUnit {
  _XBlock xBlock;

  _BlockQueryTaskUnitOLD({
    required this.xBlock,
  }) : super(taskType: TaskType.blockQuery);

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

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xBlock.block)})";
  }
}

@_TaskUnitClassAnnotation()
@_BlockQueryAnnotation()
@_BlockQueryMorePageAnnotation()
@_BlockQueryNextPageAnnotation()
@_BlockQueryPreviousPageAnnotation()
@_BlockQueryAndPrepareToEditAnnotation()
@_BlockQueryAndPrepareToCreateAnnotation()
class _BlockQueryTaskUnit extends _TaskUnit {
  _QBlock xBlock;

  _BlockQueryTaskUnit({
    required this.xBlock,
  }) : super(taskType: TaskType.blockQuery);

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

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xBlock.block)})";
  }
}
