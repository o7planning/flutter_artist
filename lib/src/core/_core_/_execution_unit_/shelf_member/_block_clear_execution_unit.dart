part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _BlockClearItemsExecutionUnit<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockClearItemsResult> {
  final XBlock xBlock;

  @override
  final BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockClearItemsExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.blockClear,
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
