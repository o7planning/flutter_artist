part of '../../core.dart';

class _LazyBlock {
  final Block block;
  final QryHint queryHint;

  _LazyBlock({required this.block, required this.queryHint});

  String toDebugString() {
    return "(${debugObjHtml(block)}, queryHint: $queryHint)";
  }
}
