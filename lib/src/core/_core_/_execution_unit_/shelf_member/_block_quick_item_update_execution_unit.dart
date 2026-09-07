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
  final BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockQuickItemUpdateExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.blockQuickUpdateItem,
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
