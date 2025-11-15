part of '../../core.dart';

class _LazyBlock {
  final Block block;
  final QryHint queryHint;

  _LazyBlock({required this.block, required this.queryHint});

  @override
  String toString() {
    return "(${block.name},queryHint: $queryHint)";
  }
}
