part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockQuickItemUpdateActionAnnotation()
class _BlockQuickItemUpdateExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockQuickItemUpdateResult> {
  XBlock xBlock;
  BlockQuickItemUpdateAction action;

  _BlockQuickItemUpdateExecutionUnit({
    required this.xBlock,
    required this.action,
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
