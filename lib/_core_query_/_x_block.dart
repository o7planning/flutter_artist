part of '../flutter_artist.dart';

class _XBlock {
  final _XShelf xShelf;
  final _XFilterModel xFilterModel;
  final Block block;

  String get name => block.name;

  int get xShelfId => xShelf.xShelfId;

  bool affectByFilterInput = false;

  // ***************************************************************************
  // Query Options:
  // ***************************************************************************

  bool __forceQuery = false;
  bool __forceReloadItem = false;

  QueryType __queryType = QueryType.realQuery;
  QueryType? get queryType => __queryType;

  ListBehavior? __listBehavior;
  SuggestedSelection? __suggestedSelection;
  PostQueryBehavior? __postQueryBehavior;
  PageableData? __pageable;

  // ***************************************************************************
  // ***************************************************************************

  final _XBlock? xBlockParent;
  final _XFormModel? xFormModel;
  final List<_XBlock> childXBlocks = [];

  // ***************************************************************************
  // Return Data:
  // ***************************************************************************

  // This property must have a null value initially.
  CurrentItemSelectionResult? currentItemSelectionResult;

  final itemDeletionResult = ItemDeletionResult();

  final queryResult = BlockQueryResult();

  // ***************************************************************************
  // ***************************************************************************

  _XBlock({
    required this.xShelf,
    required this.block,
    required this.xBlockParent,
    required this.xFilterModel,
    required this.xFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

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

  // QueryType get queryType {
  //   switch (__queryType) {
  //     case null:
  //       return forceQuery //
  //           ? QueryType.forceQuery
  //           : QueryType.queryIfNeed;
  //     case QueryType.forceQuery:
  //       return QueryType.forceQuery;
  //     case QueryType.queryIfNeed:
  //       return forceQuery //
  //           ? QueryType.forceQuery
  //           : QueryType.queryIfNeed;
  //   }
  // }

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
    // required QueryType? queryType,  (???)
    required ListBehavior? listBehavior,
    required SuggestedSelection? suggestedSelection,
    required PostQueryBehavior? postQueryBehavior,
    required PageableData? pageable,
  }) {
    // __queryType = queryType;  (???)
    __listBehavior = listBehavior;
    __suggestedSelection = suggestedSelection;
    __postQueryBehavior = postQueryBehavior;
    __pageable = pageable;
  }

  void _printParameters({required bool hasActiveUI}) {
    if (true) return;
    print("  ----> hasActiveUI **: $hasActiveUI");
    // print("  ----> queryType: $__queryType  --------> $queryType");
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
