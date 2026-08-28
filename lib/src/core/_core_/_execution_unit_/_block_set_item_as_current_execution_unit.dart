part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSetItemAsCurrentAnnotation()
@_BlockSelectNextItemAsCurrentAnnotation()
@_BlockSelectFirstItemAsCurrentAnnotation()
@_BlockSelectPreviousItemAsCurrentAnnotation()
class _BlockSetItemAsCurrentExecutionUnit<ID extends Comparable,
ITEM extends Identifiable<ID>>
    extends _ResultedSExecutionUnit<BlockSetCurrentItemResult<ITEM>> {
  final XBlock xBlock;
  final ForceType? forceTypeForForm;
  final BlockSetCurrentItemDirective setCurrentItemDirective;
  final ITEM? candidateItem;
  final List<ITEM> newQueriedList;

  _BlockSetItemAsCurrentExecutionUnit({
    required this.setCurrentItemDirective,
    required this.xBlock,
    required this.newQueriedList,
    required this.candidateItem,
    required bool forceReloadItem,
    required this.forceTypeForForm,
  }) : super(
    executionUnitType: ExecutionUnitType.blockSetItemAsCurrent,
    taskResult: BlockSetCurrentItemResult<ITEM>(
      precheck: null,
      setCurrentItemDirective: setCurrentItemDirective,
      getItemId: xBlock.block._getItemIdInternal,
      candidateItem: candidateItem,
      oldCurrentItem: xBlock.block.currentItem as ITEM?,
      currentItem: xBlock.block.currentItem as ITEM?,
    ),
  ) {
    xBlock.setForceReloadCurrItem(forceReloadItem);
    //
    if (forceTypeForForm != null) {
      xBlock.xFormModel?.setForceType(forceTypeForForm!);
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
