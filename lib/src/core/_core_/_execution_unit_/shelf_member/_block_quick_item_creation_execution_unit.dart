part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockQuickItemCreationActionAnnotation()
class _BlockQuickItemCreationExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockQuickItemCreationResult> {
  final XBlock xBlock;

  @override
  final BlockTodoQuickItemCreation executionTodo;

  _BlockQuickItemCreationExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.blockQuickCreateItem,
          executionUnitResult: BlockQuickItemCreationResult(),
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
