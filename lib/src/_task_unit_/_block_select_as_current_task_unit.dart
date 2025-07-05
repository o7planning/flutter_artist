part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSelectItemAsCurrentAnnotation()
@_BlockRefreshAndSelectNextItemAsCurrentAnnotation()
@_BlockRefreshAndSelectFirstItemAsCurrentAnnotation()
@_BlockRefreshAndSelectPreviousItemAsCurrentAnnotation()
class _BlockSelectAsCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
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
  }) : super(taskType: TaskType.blockSelectItemAsCurrent) {
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
