part of '../flutter_artist.dart';

class _BlockSelectAsCurrentTaskUnit<ITEM extends Object> extends _TaskUnit {
  final _XBlock xBlock;

  _BlockSelectAsCurrentTaskUnit({
    required this.xBlock,
    required ITEM? candidateItem,
  }) {
    xBlock._candidateCurrentItem = candidateItem;
  }
}
