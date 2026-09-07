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

  @override
  final BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockSetItemAsCurrentExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.blockSetItemAsCurrent,
          executionIntent: executionIntent,
          // executionUnitResult: BlockSetCurrentItemResult<ITEM>(
          //   precheck: null,
          //   setCurrentItemDirective: executionIntent.setCurrentItemDirective,
          //   getItemId: xBlock.block._getItemIdInternal,
          //   candidateItem: executionIntent.inputCandidateCurrItem,
          //   oldCurrentItem: xBlock.block.currentItem,
          //   currentItem: xBlock.block.currentItem,
          // ),
        ) {
    xBlock.setForceReloadCurrItem(executionIntent.forceReloadItem);
    //
    if (executionIntent.forceTypeForForm != null) {
      xBlock.xFormModel?.setForceType(executionIntent.forceTypeForForm!);
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
