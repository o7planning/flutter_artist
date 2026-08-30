part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockQuickItemCreationActionAnnotation()
class _BlockQuickItemCreationExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockQuickItemCreationResult> {
  XBlock xBlock;
  BlockQuickItemCreationAction action;

  _BlockQuickItemCreationExecutionUnit({
    required this.xBlock,
    required this.action,
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
