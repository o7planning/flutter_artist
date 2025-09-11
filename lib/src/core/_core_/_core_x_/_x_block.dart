part of '../core.dart';

class XBlock<
    ID extends Object, //
    ITEM extends Object,
    ITEM_DETAIL extends Object> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xShelfId => xShelf.xShelfId;

  final _recentLoadedItemMap = <ID, _CurrentCoupleItem<ITEM, ITEM_DETAIL>>{};

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      ExtraFormInput> block;

  XBlock get rootXBlock {
    if (parentXBlock == null) {
      return this;
    }
    return parentXBlock!.rootXBlock;
  }

  late final XBlock? parentXBlock;
  final List<XBlock> childXBlocks = [];

  final XFilterModel xFilterModel;
  final XFormModel? xFormModel;

  String get name => block.name;

  CurrentItemSelectionType? __currentItemSelectionType;
  ITEM? __candidateCurrItem;

  // Options:

  QryHint __qryHint = QryHint.none;
  bool __forceReloadCurrItem = false;
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

  bool get forceReloadCurrItem => __forceReloadCurrItem;

  SuggestedSelection? get suggestedSelection => __suggestedSelection;

  PageableData? get pageable => __pageable;

  // ***************************************************************************
  // ***************************************************************************

  // Only Used for INTERNAL EVENT.
  ITEM? __currItemInternalEVT;

  // Only Used for INTERNAL EVENT.
  ITEM? get currItemInternalEVT => __currItemInternalEVT;

  void setCurrItemToReload(ITEM? currItemInternalEVT) {
    __currItemInternalEVT = currItemInternalEVT;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XBlock, use 'block._createXBlock' method
  /// to have the same Generics Parameters with the block.
  ///
  XBlock._({
    required this.block,
    required this.xFilterModel,
    required this.xFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  bool hasQryHintInTreeBranchAndNotProcessed() {
    if (__qryHint == QryHint.force || __qryHint == QryHint.markAsPending) {
      return true;
    }
    // print("BLOCK: ${block} - CHILD: ${childXBlocks}");
    for (XBlock child in childXBlocks) {
      if (child.hasQryHintInTreeBranchAndNotProcessed()) {
        return true;
      }
    }
    return false;
  }

  bool hasAncestorTask() {
    XBlock? prXBlock = parentXBlock;
    if (prXBlock == null) {
      return false;
    }
    if (prXBlock.needToReQuery() || prXBlock.needToReloadCurrItem()) {
      return true;
    }
    return prXBlock.hasAncestorTask();
  }

  bool isRoot() {
    return parentXBlock == null;
  }

  bool isVipBranch() {
    return rootXBlock == xShelf.rootVipXBlock;
  }

  bool isReQueryDone() {
    return __qryHint == QryHint.none;
  }

  bool needToReQuery() {
    return __qryHint == QryHint.force;
  }

  void setReQueryDone() {
    __qryHint = QryHint.none;
  }

  bool needToReloadCurrItem() {
    return !isReloadCurrItemDone();
  }

  bool isReloadCurrItemDone() {
    if (currItemInternalEVT == null) {
      return true;
    }
    final ID currItemIdToReload = block.getItemId(currItemInternalEVT!);
    // TODO: Check throw pending exception.
    final ITEM? currItem = block.currentItem;
    ID? currItemId = currItem == null ? null : block.getItemId(currItem);
    if (currItemId != currItemIdToReload) {
      return true;
    }
    return !__forceReloadCurrItem;
  }

  void setForceReloadCurrItemDone() {
    __forceReloadCurrItem = false;
  }

  void setQueryHint(QryHint queryHint) {
    __qryHint = queryHint;
  }

  void setQueryHintToGreater(QryHint queryHint) {
    if (__qryHint.isLessThan(queryHint)) {
      __qryHint = queryHint;
    }
  }

  void setForceReloadCurrItem(bool forceReloadCurrItem) {
    __forceReloadCurrItem = forceReloadCurrItem;
  }

  ITEM? get candidateCurrItem => __candidateCurrItem;

  void setCandidateCurrItem(ITEM? candidateCurrItem) {
    __candidateCurrItem = candidateCurrItem;
  }

  CurrentItemSelectionType? get currentItemSelectionType =>
      __currentItemSelectionType;

  void setCurrentItemSelectionType(
      CurrentItemSelectionType? currentItemSelectionType) {
    __currentItemSelectionType = currentItemSelectionType;
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

  void _addRecentLoadedItem({
    required ID itemId,
    required ITEM item,
    required ITEM_DETAIL itemDetail,
  }) {
    _recentLoadedItemMap[itemId] = _CurrentCoupleItem(
      item: item,
      itemDetail: itemDetail,
    );
  }

  _CurrentCoupleItem? _getRecentLoadedItem({required ID itemId}) {
    return _recentLoadedItemMap[itemId];
  }

  void _printParameters({required bool hasActiveUI}) {
    //
  }

  void printInfoCascade() {
    bool hasActiveUI = block.ui.hasActiveUIComponent(alsoCheckChildren: false);
    String msg =
        "${getClassName(this)}(${getClassName(block)} - UIActive: $hasActiveUI - QryHint: $__qryHint - RefreshItem: $__forceReloadCurrItem";
    print(msg);
    for (XBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(block)} - qryHint: $queryHint) forceReloadItem: $__forceReloadCurrItem - $xFormModel";
  }
}
