part of '../core.dart';

class _QBlock {
  _QShelf get xShelf => xFilterModel.xShelf;
  int get xShelfId => xShelf.xShelfId;

  final Block block;

  late final _QBlock? parentXBlock;
  final List<_QBlock> childXBlocks = [];

  final _QFilterModel xFilterModel;
  final _QFormModel? xFormModel;

  String get name => block.name;

  bool _processed = false;

  // Options:

  QryHint __forceQuery = QryHint.none;
  bool __forceReloadItem = false;
  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  ListBehavior? __listBehavior;
  SuggestedSelection? __suggestedSelection;
  PostQueryBehavior? __postQueryBehavior;
  PageableData? __pageable;

  final queryResult = BlockQueryResult._();

  // ***************************************************************************

  QryHint get forceQuery => __forceQuery;

  bool get forceReloadItem => __forceReloadItem;

  SuggestedSelection? get suggestedSelection => __suggestedSelection;

  PageableData? get pageable => __pageable;

  // ***************************************************************************
  // ***************************************************************************

  _QBlock({
    required this.block,
    required this.xFilterModel,
    required this.xFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  bool hasQryHintInTreeBranchAndNotProcessed() {
    if (__forceQuery == QryHint.force ||
        __forceQuery == QryHint.markAsPending) {
      if (!_processed) {
        return true;
      }
    }
    for (_QBlock child in childXBlocks) {
      if (child.hasQryHintInTreeBranchAndNotProcessed()) {
        return true;
      }
    }
    return false;
  }

  void setForceQuery(QryHint forceQuery) {
    __forceQuery = forceQuery;
  }

  void setForceReloadItem() {
    __forceReloadItem = true;
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
        "${getClassName(this)}(${getClassName(block)} - UIActive: $hasActiveUI - ForceQuery: $__forceQuery - RefreshItem: $__forceReloadItem";
    print(msg);
    for (_QBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }
}
