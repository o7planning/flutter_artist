part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSetItemAsCurrentAnnotation()
@_BlockSelectNextItemAsCurrentAnnotation()
@_BlockSelectFirstItemAsCurrentAnnotation()
@_BlockSelectPreviousItemAsCurrentAnnotation()
class _BlockSetItemAsCurrentExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<BlockSetCurrentItemResult<ITEM>> {
  final XBlock<ID, ITEM, ITEM_DETAIL> xBlock;
  final BlockTodoSetCurrentItem<ID, ITEM, ITEM_DETAIL> executionTodo;

  _BlockSetItemAsCurrentExecutionUnit({
    required this.xBlock,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.blockSetItemAsCurrent,
          executionUnitResult: BlockSetCurrentItemResult<ITEM>(
            precheck: null,
            setCurrentItemDirective: executionTodo.setCurrentItemDirective,
            getItemId: xBlock.block._getItemIdInternal,
            candidateItem: executionTodo.inputCandidateCurrItem,
            oldCurrentItem: xBlock.block.currentItem as ITEM?,
            currentItem: xBlock.block.currentItem as ITEM?,
          ),
        ) {
    xBlock.setForceReloadCurrItem(executionTodo.forceReloadItem);
    //
    if (executionTodo.forceTypeForForm != null) {
      xBlock.xFormModel?.setForceType(executionTodo.forceTypeForForm!);
    }
  }

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
