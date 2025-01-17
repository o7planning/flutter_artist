part of '../flutter_artist.dart';

class _XBlock {
  bool needQuery = false;
  final Block block;

  final _XDataFilter xDataFilter;

  // Query Options:
  QueryType? queryType;
  ListBehavior? listBehavior;
  SuggestedSelection? suggestedSelection;
  PostQueryBehavior? postQueryBehavior;
  PageableData? pageable;

  //
  final _XBlock? xBlockParent;
  final _XBlockForm? xBlockForm;
  final List<_XBlock> childXBlocks = [];

  _XBlock({
    required this.block,
    required this.xBlockParent,
    required this.xDataFilter,
    required this.xBlockForm,
  });

  void setOptions({
    required QueryType? queryType,
    required ListBehavior? listBehavior,
    required SuggestedSelection? suggestedSelection,
    required PostQueryBehavior? postQueryBehavior,
    required PageableData? pageable,
  }) {
    this.queryType = queryType;
    this.listBehavior = listBehavior;
    this.suggestedSelection = suggestedSelection;
    this.postQueryBehavior = postQueryBehavior;
    this.pageable = pageable;
  }

  String get name => block.name;
}
