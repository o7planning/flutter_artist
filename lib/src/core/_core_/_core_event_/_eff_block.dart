part of '../core.dart';

class _EffBlock {
  final bool requery;
  final BlockViewportSyncStrategy? viewportSyncStrategy;
  final bool refreshCurrItem;
  final Block block;

  _EffBlock({
    required this.block,
    required this.requery,
    required this.viewportSyncStrategy,
    required this.refreshCurrItem,
  });

  XBlock getXBlock({required XShelf xShelf}) {
    return xShelf.findXBlockByName(block.name)!;
  }

  String getDebugInfo() {
    return "${block.name}(requery: $requery, viewportSyncStrategy: ${viewportSyncStrategy?.name}, refreshCurrItem: $refreshCurrItem)";
  }
}
