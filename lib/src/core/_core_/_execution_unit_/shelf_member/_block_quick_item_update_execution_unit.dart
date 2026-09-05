part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockQuickItemUpdateActionAnnotation()
class _BlockQuickItemUpdateExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockQuickItemUpdateResult> {
  final XBlock xBlock;

  @override
  final BlockTodoQuickItemUpdate executionTodo;

  _BlockQuickItemUpdateExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.blockQuickUpdateItem,
          executionUnitResult: BlockQuickItemUpdateResult(),
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
