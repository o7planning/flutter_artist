part of '../flutter_artist.dart';

class _BlockSelectAsCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _XBlock xBlock;
  final _Force? forceForm;
  final CurrentItemSelectionType currentItemSelectionType;
  final ITEM? candidateItem;
  final List<ITEM> newQueriedList;

  _BlockSelectAsCurrentTaskUnit({
    required this.currentItemSelectionType,
    required this.xBlock,
    required this.newQueriedList,
    required this.candidateItem,
    required bool forceReloadItem,
    required this.forceForm,
  }) : super(taskType: TaskType.blockSelectItemAsCurrent) {
    if (forceReloadItem) {
      xBlock.setForceReloadItem();
    }
    //
    if (forceForm != null) {
      xBlock.xFormModel?.forceForm = forceForm!;
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
