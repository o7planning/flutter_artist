part of '../core.dart';

class XBlock<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xShelfId => xShelf.xShelfId;

  final _recentLoadedItemMap = <ID, _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL>>{};

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      FormRelatedData,
      FormInput> block;

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

  ItemListMode? __itemListMode;
  SuggestedSelection? __suggestedSelection;
  AfterQueryAction? __afterQueryAction;
  Pageable? __pageable;

  // TODO: Chuyen sang BlockQueryResult?
  late final PrepareItemCreationResult itemCreationResult =
      block._createEmptyItemCreationResult();
  final queryResult = BlockQueryResult._();

  // ***************************************************************************

  QryHint get queryHint => __qryHint;

  bool get forceReloadCurrItem => __forceReloadCurrItem;

  SuggestedSelection? get suggestedSelection => __suggestedSelection;

  Pageable? get pageable => __pageable;

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

  _BlockReQryCon? _blockReQryCon;

  _BlockItemRefreshCon? _blockItemRefreshCon;

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
  }) {
    _blockReQryCon = block._blockReQryCon;
    _blockItemRefreshCon = block._blockItemRefreshCon;
    //
    block._blockReQryCon = null;
    block._blockItemRefreshCon = null;
  }

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
    final ID currItemIdToReload =
        block._getItemIdInternal(currItemInternalEVT!);
    // TODO: Check throw pending exception.
    final ITEM? currItem = block.currentItem;
    ID? currItemId =
        currItem == null ? null : block._getItemIdInternal(currItem);
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

  ItemListMode get itemListMode {
    // TODO: Xem lai gia tri mac dinh
    return __itemListMode ?? ItemListMode.replace;
  }

  set suggestedSelection(value) {
    __suggestedSelection = value;
  }

  AfterQueryAction get afterQueryAction {
    return __afterQueryAction ?? FlutterArtist.defaultAfterQueryAction;
  }

  void setOptions({
    required QueryType queryType,
    required ItemListMode? itemListMode,
    required SuggestedSelection? suggestedSelection,
    required AfterQueryAction? afterQueryAction,
    required Pageable? pageable,
  }) {
    __queryType = queryType;
    __itemListMode = itemListMode;
    __suggestedSelection = suggestedSelection;
    __afterQueryAction = afterQueryAction;
    __pageable = pageable;
  }

  void _addRecentLoadedItem({
    required ID itemId,
    required ITEM item,
    required ITEM_DETAIL itemDetail,
  }) {
    _recentLoadedItemMap[itemId] = _BlockItem2Wrap(
      id: itemId,
      item: item,
      itemDetail: itemDetail,
    );
  }

  _BlockItem2Wrap? _getRecentLoadedItem({required ID itemId}) {
    return _recentLoadedItemMap[itemId];
  }

  void _printParameters({required bool hasBlockRepresentative}) {
    //
  }

  void printInfoCascade() {
    bool hasBlockRepresentative =
        block.ui.hasActiveUIComponentBlockRepresentative(
      alsoCheckChildren: false,
    );
    String msg = "${getClassName(this)}(${getClassName(block)}"
        " - HasBlockRepresentative: $hasBlockRepresentative"
        " - QryHint: $__qryHint - RefreshItem: $__forceReloadCurrItem";
    print(msg);
    for (XBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }

  @override
  String toString() {
    return "XBlock (${getClassName(block)}) \n"
        "      - qryHint: $queryHint / blockReQryCon: $_blockReQryCon \n"
        "      - forceReloadItem: $__forceReloadCurrItem / blockItemRefreshCon: $_blockItemRefreshCon \n"
        "      - xFormModel: $xFormModel";
  }
}
