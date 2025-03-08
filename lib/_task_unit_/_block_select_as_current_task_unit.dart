part of '../flutter_artist.dart';

class _BlockSelectAsCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _XBlock xBlock;
  final bool? forceForm;
  final CurrentItemSelectionType currentItemSelectionType;
  final ITEM? candidateItem;

  _BlockSelectAsCurrentTaskUnit({
    required this.currentItemSelectionType,
    required this.xBlock,
    required this.candidateItem,
    required this.forceForm,
  }) {
    xBlock.setForceReloadItem();
    if (forceForm != null) {
      xBlock.xBlockForm?.forceForm = forceForm!;
    }
  }


  @override
  Shelf get shelf =>xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
