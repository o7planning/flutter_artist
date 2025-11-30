part of '../../core.dart';

class _LazyBlock {
  final Block block;
  final QryHint queryHint;

  _LazyBlock({required this.block, required this.queryHint});

  String toDebugString() {
    return "${_debugObjHtml(block)}, queryHint: $queryHint";
  }
}
