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

  XBlock getXBlock({required XShelf xShelf}) {
    return xShelf.findXBlockByName(block.name)!;
  }

  String getDebugInfo() {
    return "${block.name}(reQuery: $reQuery, refreshCurrItem: $refreshCurrItem)";
  }
}
