part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockItemDeletionExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockItemDeletionResult<ITEM>> {
  XBlock xBlock;

  @override
  final BlockTodoDeleteItem<ID, ITEM, ITEM_DETAIL> executionTodo;

  _BlockItemDeletionExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
    // required super.executionUnitResult,
  }) : super(
          executionUnitType: ExecutionUnitType.blockDeleteItem,
          executionUnitResult:
              BlockItemDeletionResult(candidateItem: executionTodo.item),
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
