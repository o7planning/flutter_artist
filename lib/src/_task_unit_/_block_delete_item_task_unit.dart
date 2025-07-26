part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockDeleteItemTaskUnit extends _TaskUnit<ItemDeletionResult> {
  _XBlock xBlock;
  final Object item;

  _BlockDeleteItemTaskUnit({
    required this.xBlock,
    required this.item,
    required super.result,
  }) : super(taskType: TaskType.blockDeleteItem);

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
