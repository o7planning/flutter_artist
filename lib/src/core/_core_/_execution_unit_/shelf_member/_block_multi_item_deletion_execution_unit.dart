part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockMultiItemDeletionExecutionUnit<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockItemsDeletionResult> {
  final XBlock xBlock;

  @override
  final BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockMultiItemDeletionExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.blockDeleteItems,
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
