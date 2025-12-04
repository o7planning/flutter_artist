part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSelectItemAsCurrentAnnotation()
@_BlockSelectNextItemAsCurrentAnnotation()
@_BlockSelectFirstItemAsCurrentAnnotation()
@_BlockSelectPreviousItemAsCurrentAnnotation()
class _BlockSelectAsCurrentTaskUnit<ID extends Object,
ITEM extends Identifiable<ID>>
    extends _ResultedSTaskUnit<BlockItemCurrSelectionResult<ITEM>> {
  final XBlock xBlock;
  final ForceType? forceTypeForForm;
  final CurrentItemSelectionType currentItemSelectionType;
  final ITEM? candidateItem;
  final List<ITEM> newQueriedList;

  _BlockSelectAsCurrentTaskUnit({
    required this.currentItemSelectionType,
    required this.xBlock,
    required this.newQueriedList,
    required this.candidateItem,
    required bool forceReloadItem,
    required this.forceTypeForForm,
  }) : super(
    taskType: TaskType.blockSetItemAsCurrent,
    taskResult: BlockItemCurrSelectionResult<ITEM>(
      precheck: null,
      currentItemSelectionType: currentItemSelectionType,
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
