part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockPrepareFormToCreateItemExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XBlock xBlock;

  @override
  final BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>
      executionIntent;

  _BlockPrepareFormToCreateItemExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.blockPrepareToCreateItem,
          executionIntent: executionIntent,
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
