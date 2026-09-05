part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockBackendActionAnnotation()
class _BlockBackendActionExecutionUnit<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>>
    extends  _ShelfMemberResultedExecutionUnit<BlockBackendActionResult> {
  final XBlock xBlock;

  @override
  final BlockTodoBackendAction<ID,ITEM,ITEM_DETAIL> executionTodo;

  _BlockBackendActionExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.blockBackendAction,
          executionUnitResult: BlockBackendActionResult(),
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
