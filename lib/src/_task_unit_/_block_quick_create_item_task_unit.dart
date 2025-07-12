part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockExecuteQuickActionCreateItemAnnotation()
class _BlockQuickCreateItemTaskUnit extends _TaskUnit {
  _XBlock xBlock;
  BlockQuickCreateItemAction action;

  _BlockQuickCreateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(taskType: TaskType.blockQuickCreateItem);

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
