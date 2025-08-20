part of '../core.dart';

class _XBlock {
  _XShelf get xShelf => xFilterModel.xShelf;

  int get xShelfId => xShelf.xShelfId;

  final Block block;

  late final _XBlock? parentXBlock;
  final List<_XBlock> childXBlocks = [];

  final _XFilterModel xFilterModel;
  final _XFormModel? xFormModel;

  String get name => block.name;

  bool _processed = false;

  // Options:

  QryHint __qryHint = QryHint.none;
  bool __forceReloadItem = false;
  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  ListBehavior? __listBehavior;
  SuggestedSelection? __suggestedSelection;
  PostQueryBehavior? __postQueryBehavior;
  PageableData? __pageable;

  // TODO: Chuyen sang BlockQueryResult?
  late final PrepareItemCreationResult itemCreationResult =
      block._createEmptyItemCreationResult();
  final queryResult = BlockQueryResult._();

  // ***************************************************************************

  QryHint get queryHint => __qryHint;

  bool get forceReloadItem => __forceReloadItem;

  SuggestedSelection? get suggestedSelection => __suggestedSelection;

  PageableData? get pageable => __pageable;

  // ***************************************************************************
  // ***************************************************************************

  _XBlock({
    required this.block,
    required this.xFilterModel,
    required this.xFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  bool hasQryHintInTreeBranchAndNotProcessed() {
    if (__qryHint == QryHint.force || __qryHint == QryHint.markAsPending) {
      if (!_processed) {
        return true;
      }
    }
    // print("BLOCK: ${block} - CHILD: ${childXBlocks}");
    for (_XBlock child in childXBlocks) {
      if (child.hasQryHintInTreeBranchAndNotProcessed()) {
        return true;
      }
    }
    return false;
  }

  void setQueryHint(QryHint queryHint) {
    __qryHint = queryHint;
  }

  void setForceReloadItem(bool forceReloadItem) {
    __forceReloadItem = forceReloadItem;
  }

  ListBehavior get listBehavior {
    // TODO: Xem lai gia tri mac dinh
    return __listBehavior ?? ListBehavior.replace;
  }

  set suggestedSelection(value) {
    __suggestedSelection = value;
  }

  PostQueryBehavior get postQueryBehavior {
    return __postQueryBehavior ?? FlutterArtist.defaultPostQueryBehavior;
  }

  void setOptions({
    required QueryType queryType,
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

  void _printParameters({required bool hasActiveUI}) {
    //
  }

  void printInfoCascade() {
    bool hasActiveUI = block.ui.hasActiveUIComponent(alsoCheckChildren: false);
    String msg =
        "${getClassName(this)}(${getClassName(block)} - UIActive: $hasActiveUI - QryHint: $__qryHint - RefreshItem: $__forceReloadItem";
    print(msg);
    for (_XBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(block)} - qryHint: $queryHint) forceReloadItem: $__forceReloadItem - $xFormModel";
  }
}
