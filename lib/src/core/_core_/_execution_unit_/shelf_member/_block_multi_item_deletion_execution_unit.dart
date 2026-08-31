part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockDeleteSelectedItemsAnnotation()
@_BlockDeleteCheckedItemsAnnotation()
@_BlockDeleteCurrentItemAnnotation()
@_BlockDeleteItemAnnotation()
class _BlockMultiItemDeletionExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockItemsDeletionResult> {
  XBlock xBlock;
  final List<ITEM> items;
  final bool stopIfError;

  _BlockMultiItemDeletionExecutionUnit({
    required this.xBlock,
    required this.items,
    required super.executionUnitResult,
    required this.stopIfError,
  }) : super(
          executionUnitType: ExecutionUnitType.blockDeleteItems,
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
