part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSetItemAsCurrentAnnotation()
@_BlockSelectNextItemAsCurrentAnnotation()
@_BlockSelectFirstItemAsCurrentAnnotation()
@_BlockSelectPreviousItemAsCurrentAnnotation()
class _BlockSetItemAsCurrentTaskUnit<ID extends Object,
        ITEM extends Identifiable<ID>>
    extends _ResultedSTaskUnit<BlockCurrentItemSettingResult<ITEM>> {
  final XBlock xBlock;
  final ForceType? forceTypeForForm;
  final CurrentItemSettingType currentItemSettingType;
  final ITEM? candidateItem;
  final List<ITEM> newQueriedList;

  _BlockSetItemAsCurrentTaskUnit({
    required this.currentItemSettingType,
    required this.xBlock,
    required this.newQueriedList,
    required this.candidateItem,
    required bool forceReloadItem,
    required this.forceTypeForForm,
  }) : super(
          taskType: TaskType.blockSetItemAsCurrent,
          taskResult: BlockCurrentItemSettingResult<ITEM>(
            precheck: null,
            currentItemSettingType: currentItemSettingType,
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
