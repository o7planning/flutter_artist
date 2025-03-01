part of '../flutter_artist.dart';

class _XBlock {
  bool __forceQuery = false;
  bool __forceReloadItem = false;

  bool affectByFilterInput = false;
  final Block block;
  final _XDataFilter xDataFilter;

  String get name => block.name;

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

  //
  Object? _candidateCurrentItem;
  _CurrentCoupleItem _stateCurrent = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );
  List<Object> _stateSelectedItems = [];
  List<Object> _stateCheckedItems = [];

  _XBlock({
    required this.block,
    required this.xBlockParent,
    required this.xDataFilter,
    required this.xBlockForm,
  });

  void setState({
    required Object? candidateCurrentItem,
    required Object? stateCurrentItem,
    required Object? stateCurrentItemDetail,
    required List<Object> stateSelectedItems,
    required List<Object> stateCheckedItems,
  }) {
    _candidateCurrentItem = candidateCurrentItem;
    _stateCurrent = _CurrentCoupleItem(
      item: stateCurrentItem,
      itemDetail: stateCurrentItemDetail,
    );
    _stateSelectedItems.addAll(stateSelectedItems);
    _stateCheckedItems.addAll(stateCheckedItems);
  }

  bool get forceQuery {
    return __forceQuery;
  }

  bool get forceReloadItem {
    return __forceReloadItem;
  }

  void setForceQuery() {
    __forceQuery = true;
  }

  void setForceReloadItem() {
    __forceReloadItem = true;
  }

  QueryType get queryType {
    switch (__queryType) {
      case null:
        return forceQuery //
            ? QueryType.forceQuery
            : QueryType.queryIfNeed;
      case QueryType.forceQuery:
        return QueryType.forceQuery;
      case QueryType.queryIfNeed:
        return forceQuery //
            ? QueryType.forceQuery
            : QueryType.queryIfNeed;
    }
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

  void printParameters() {
    print("  ----> candidateCurrentItem: $_candidateCurrentItem");
    print("  ----> queryType: $__queryType  --------> $queryType");
    print("  ----> forceQuery: $__forceQuery  --------> $forceQuery");
    print(
        "  ----> forceReloadItem: $__forceReloadItem  --------> $forceReloadItem");
    print("  ----> listBehavior: $__listBehavior  --------> $listBehavior");
    print(
        "  ----> postQueryBehavior: $__postQueryBehavior  --------> $postQueryBehavior");
    print("  ----> pageable: $__pageable  --------> $pageable");
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(block)} - needQuery: $forceQuery)";
  }
}
