part of '../flutter_artist.dart';

class _XBlock {
  bool needQuery = false;
  final Block block;

  final _XDataFilter xDataFilter;

  // Query Options:
  QueryType? __queryType;
  ListBehavior? __listBehavior;
  SuggestedSelection? __suggestedSelection;
  PostQueryBehavior? __postQueryBehavior;
  PageableData? __pageable;

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

  QueryType get queryType {
    // TODO: Xem lai gia tri mac dinh
    return __queryType ?? QueryType.queryIfNeed;
  }

  ListBehavior get listBehavior {
    // TODO: Xem lai gia tri mac dinh
    return __listBehavior ?? ListBehavior.replace;
  }

  SuggestedSelection? get suggestedSelection {
    return __suggestedSelection;
  }

  set suggestedSelection(value) {
    __suggestedSelection = value;
  }

  PostQueryBehavior get postQueryBehavior {
    // TODO: Xem lai gia tri mac dinh
    return __postQueryBehavior ?? PostQueryBehavior.selectAvailableItem;
  }

  PageableData? get pageable {
    return __pageable;
  }

  void setOptions({
    required QueryType? queryType,
    required ListBehavior? listBehavior,
    required SuggestedSelection? suggestedSelection,
    required PostQueryBehavior? postQueryBehavior,
    required PageableData? pageable,
  }) {
    __queryType = queryType;
    __listBehavior = listBehavior;
    __suggestedSelection = suggestedSelection;
    __postQueryBehavior = postQueryBehavior;
    __pageable = pageable;
  }

  String get name => block.name;

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(block)} - needQuery: $needQuery)";
  }
}
