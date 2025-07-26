part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSelectItemAsCurrentAnnotation()
@_BlockRefreshAndSelectNextItemAsCurrentAnnotation()
@_BlockRefreshAndSelectFirstItemAsCurrentAnnotation()
@_BlockRefreshAndSelectPreviousItemAsCurrentAnnotation()
class _BlockSelectAsCurrentTaskUnit<ITEM extends Object>
    extends _TaskUnit<BlockItemCurrSelectionResult<ITEM>> {
  final _XBlock xBlock;
  final _ForceType? forceTypeForForm;
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
          taskType: TaskType.blockSelectItemAsCurrent,
          taskResult: BlockItemCurrSelectionResult<ITEM>(
            precheck: null,
            currentItemSelectionType: currentItemSelectionType,
            getItemId: xBlock.block.getItemId,
            candidateItem: candidateItem,
            oldCurrentItem: xBlock.block.currentItem as ITEM?,
            currentItem: xBlock.block.currentItem as ITEM?,
          ),
        ) {
    if (forceReloadItem) {
      xBlock.setForceReloadItem();
    }
    //
    if (forceTypeForForm != null) {
      xBlock.xFormModel?.forceTypeForForm = forceTypeForForm!;
    }
  }

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
