part of '../core.dart';

class _EffBlock {
  final bool reQuery;
  final bool refreshCurrItem;
  final Block block;

  _EffBlock({
    required this.block,
    required this.reQuery,
    required this.refreshCurrItem,
  });
}
