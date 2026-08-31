part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockPrepareFormToCreateItemExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XBlock xBlock;
  final BlockTodoPrepareFormToCreateItem<ID, ITEM, ITEM_DETAIL> executionTodo;

  _BlockPrepareFormToCreateItemExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.blockPrepareToCreateItem,
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
