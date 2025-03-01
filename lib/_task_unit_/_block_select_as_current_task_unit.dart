part of '../flutter_artist.dart';

class _BlockSelectAsCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _XBlock xBlock;
  final bool? forceForm;

  _BlockSelectAsCurrentTaskUnit({
    required this.xBlock,
    required ITEM? candidateItem,
    required this.forceForm,
  }) {
    xBlock._candidateCurrentItem = candidateItem;
    xBlock.setForceReloadItem();
    if (forceForm != null) {
      xBlock.xBlockForm?.needQuery = forceForm!;
    }
  }
}
