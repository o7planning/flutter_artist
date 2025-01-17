part of '../flutter_artist.dart';

class _XBlock {
  bool needQuery = false;
  final Block block;

  final _XBlock? xBlockParent;
  final _XBlockForm? xBlockForm;
  final List<_XBlock> childXBlocks = [];

  _XBlock({
    required this.block,
    required this.xBlockParent,
    required this.xBlockForm,
  });

  String get name => block.name;
}
