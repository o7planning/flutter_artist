part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickCreateMultiItemsActionAnnotation()
class _BlockQuickCreateMultiItemsTaskUnit extends _TaskUnit {
  _XBlock xBlock;

  BlockQuickCreateMultiItemsAction action;

  _BlockQuickCreateMultiItemsTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(taskType: TaskType.blockQuickCreateMultiItems);

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
