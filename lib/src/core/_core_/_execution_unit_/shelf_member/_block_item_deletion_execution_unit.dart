part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockItemDeletionExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockItemDeletionResult<ITEM>> {
  XBlock xBlock;
  final ITEM item;

  _BlockItemDeletionExecutionUnit({
    required this.xBlock,
    required this.item,
    required super.taskResult,
  }) : super(executionUnitType: ExecutionUnitType.blockDeleteItem);

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
