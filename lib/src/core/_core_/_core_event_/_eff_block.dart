part of '../core.dart';

class EffBlock {
  final bool reQuery;
  final bool refreshCurrItem;
  final Block block;

  EffBlock({
    required this.block,
    required this.reQuery,
    required this.refreshCurrItem,
  });
}
