part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockBackendActionAnnotation()
class _BlockBackendActionExecutionUnit<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockBackendActionResult> {
  final XBlock xBlock;

  @override
  final BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockBackendActionExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.blockBackendAction,
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
