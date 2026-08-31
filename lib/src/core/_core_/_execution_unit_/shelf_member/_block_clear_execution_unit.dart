part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
class _BlockClearItemsExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockClearItemsResult> {
  final XBlock xBlock;

  _BlockClearItemsExecutionUnit({
    required this.xBlock,
  }) : super(
          executionUnitType: ExecutionUnitType.blockClear,
          executionUnitResult: BlockClearItemsResult(
            precheck: null,
          ),
        );


  @override
  BlockTodo? get executionTodo => null;


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
