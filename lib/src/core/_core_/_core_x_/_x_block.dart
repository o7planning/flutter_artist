part of '../core.dart';

class XBlock<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xShelfId => xShelf.xShelfId;

  BlockTodo<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionTodo;

  bool _reviewed = false;

  final _recentLoadedItemMap = <ID, _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL>>{};

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      FormInput,
      AdditionalFormRelatedData> block;

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

  List<XBlock> getDescendantXBlocks({required bool sameFilterOnly}) {
    final List<XBlock> ret = [];
    final thisFm = block.registeredOrDefaultFilterModel;
    for (XBlock childXBlock in childXBlocks) {
      FilterModel fmc = childXBlock.block.registeredOrDefaultFilterModel;
      if (!sameFilterOnly || (sameFilterOnly && fmc == thisFm)) {
        ret.add(childXBlock);
      }
      ret.addAll(
        childXBlock.getDescendantXBlocks(sameFilterOnly: sameFilterOnly),
      );
    }
    return ret;
  }

  String get name => block.name;

  BlockSetCurrentItemDirective? __setCurrentItemDirective;
  ITEM? __candidateCurrItem;

  BlockViewportSyncStrategy? get viewportSyncStrategy => __viewportSyncStrategy;

  // Options:

  BlockViewportSyncStrategy? __viewportSyncStrategy;
  QryHint __qryHint = QryHint.none;
  bool __forceReloadCurrItem = false;
  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  // @Deprecated("Xoa di")
  // bool _isQueryMoreFlow = false;
  ListUpdateStrategy? __listUpdateStrategy;
  SuggestedSelection? __suggestedSelection;
  BlockAfterQueryDirective? __afterQueryDirective;
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

  Pageable? getWillBeUsedPageable(QueryType queryType) {
    switch (queryType) {
      case QueryType.realQuery:
        Pageable? usedPageable = block.effectiveConfig.nativeQueryMode ==
                BlockNativeQueryMode.fullQuery
            ? null
            : (pageable ?? block.config.pageable);
        return usedPageable;
      case QueryType.emptyQuery:
        Pageable? usedPageable = block.effectiveConfig.nativeQueryMode ==
                BlockNativeQueryMode.fullQuery
            ? null
            : block.__blockData._emptyPageable;
        return usedPageable;
    }
  }

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

  _BlockSetItemAsCurrentExecutionUnit createBlockSetItemAsCurrentExecutionUnit({
    required BlockSetCurrentItemDirective setCurrentItemDirective,
    required List<Object> newQueriedList, // Do not change <Object>
    required Object? candidateItem, // Do not change <Object>
    required bool forceReloadItem,
    required ForceType? forceTypeForForm,
  }) {
    // return _BlockSetItemAsCurrentExecutionUnit<ID, ITEM>(
    //   setCurrentItemDirective: setCurrentItemDirective,
    //   xBlock: this,
    //   newQueriedList: newQueriedList.whereType<ITEM>().toList(),
    //   candidateItem: candidateItem as ITEM?,
    //   forceReloadItem: forceReloadItem,
    //   forceTypeForForm: forceTypeForForm,
    // );
    throw UnimplementedError("TODO 112");
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

  bool hasAncestorWork() {
    XBlock? prXBlock = parentXBlock;
    if (prXBlock == null) {
      return false;
    }
    if (prXBlock.needToReQuery() || prXBlock.needToReloadCurrItem()) {
      return true;
    }
    return prXBlock.hasAncestorWork();
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
    if (queryHint == QryHint.markAsPending) {
      print("******** setQueryHintToGreater *************\n");
      print(StackTrace.current);
    }
    if (__qryHint.isLessThan(queryHint)) {
      __qryHint = queryHint;
    }
  }

  void setViewportSyncStrategy(BlockViewportSyncStrategy viewportSyncStrategy) {
    __viewportSyncStrategy = viewportSyncStrategy;
  }

  void setForceReloadCurrItem(bool forceReloadCurrItem) {
    __forceReloadCurrItem = forceReloadCurrItem;
  }

  ITEM? get candidateCurrItem => __candidateCurrItem;

  void setCandidateCurrItem(ITEM? candidateCurrItem) {
    __candidateCurrItem = candidateCurrItem;
  }

  BlockSetCurrentItemDirective? get setCurrentItemDirective =>
      __setCurrentItemDirective;

  void setBlockSetCurrentItemDirective(
      BlockSetCurrentItemDirective? setCurrentItemDirective) {
    __setCurrentItemDirective = setCurrentItemDirective;
  }

  ListUpdateStrategy? get listUpdateStrategy {
    // TODO: Xem lai gia tri mac dinh
    return __listUpdateStrategy; // ?? ListUpdateStrategy.replace;
  }

  set suggestedSelection(value) {
    __suggestedSelection = value;
  }

  BlockAfterQueryDirective get afterQueryDirective {
    return __afterQueryDirective ?? FlutterArtist.defaultAfterQueryDirective;
  }

  void setOptions({
    required QueryType queryType,
    required ListUpdateStrategy? listUpdateStrategy,
    required SuggestedSelection? suggestedSelection,
    required BlockAfterQueryDirective? afterQueryDirective,
    required Pageable? pageable,
  }) {
    __queryType = queryType;
    __listUpdateStrategy = listUpdateStrategy;
    __suggestedSelection = suggestedSelection;
    __afterQueryDirective = afterQueryDirective;
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

  // ***************************************************************************
  // ***************************************************************************

  // Block only (Not find in FilterModel, FormModel)
  NextExecutionUnit __getNextExecutionUnit({required bool debug}) {
    final bool isVisibleX =
        block.ui.hasActiveUiComponent(alsoCheckChildren: true);
    final blockDataState = block.dataState;
    if (_executionTodo == null) {
      // (IN _executionTodo = null). dataState = None
      if (blockDataState.isNone) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "Block (1.1), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      }
      // (IN _executionTodo = null). dataState = Pending
      else if (blockDataState.isPending) {
        if (__qryHint == QryHint.force || isVisibleX) {
          _createAndSetBlockTodoQuery();
          //
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              blockTodoQuery: _executionTodo as BlockTodoQuery,
            ),
            info:
                "Block (1.2.1), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "Block (1.2.2), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
      }
      // (IN _executionTodo = null). dataState = Stale.
      else if (blockDataState.isStale) {
        if (__qryHint == QryHint.force || isVisibleX) {
          _createAndSetBlockTodoQuery();
          //
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              blockTodoQuery: _executionTodo as BlockTodoQuery,
            ),
            info:
                "Block (1.3.1), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "Block (1.3.2), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
      }
      // (IN _executionTodo = null). dataState = Fresh.
      else if (blockDataState.isFresh) {
        if (__qryHint == QryHint.force) {
          _createAndSetBlockTodoQuery();
          //
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              blockTodoQuery: _executionTodo as BlockTodoQuery,
            ),
            info:
                "Block (1.4.1), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "Block (1.4.2), ${getClassNameWithoutGenerics(block)}, _executionTodo: $_executionTodo, dataState: ${blockDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
      }
      // (IN _executionTodo = null). dataState = OTHERS
      else {
        throw UnimplementedError("Never run (XBlock) - 1, dataState: ${blockDataState.toBriefInfo()}");
      }
    }
    //
    // _executionTodo != null.
    //
    final blockTodo = _executionTodo!;
    // BlockTodoDone
    if (blockTodo is BlockTodoDone) {
      return NextExecutionUnit.no(
        debug: debug,
        info:
            "Block (2), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoNull
    else if (blockTodo is BlockTodoNull) {
      if (blockDataState.isNone) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "Block (3.1), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isPending) {
        _createAndSetBlockTodoQuery();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit(
            xBlock: this,
            blockTodoQuery: _executionTodo as BlockTodoQuery,
          ),
          info:
              "Block (3.2), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isStale) {
        _createAndSetBlockTodoQuery();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit(
            xBlock: this,
            blockTodoQuery: _executionTodo as BlockTodoQuery,
          ),
          info:
              "Block (3.3), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isFresh) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "Block (3.4), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else {
        throw UnimplementedError("Never run (XBlock) - 2");
      }
    }
    // BlockTodoQuery
    else if (blockTodo is BlockTodoQuery) {
      blockTodo as BlockTodoQuery<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockQueryExecutionUnit(
          xBlock: this,
          blockTodoQuery: _executionTodo as BlockTodoQuery,
        ),
        info:
            "Block (4), ${getClassNameWithoutGenerics(block)}, _executionTodo: $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoSetCurrentItem
    else if (blockTodo is BlockTodoSetCurrentItem) {
      blockTodo as BlockTodoSetCurrentItem<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (5), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoClearCurrentItem
    else if (blockTodo is BlockTodoClearCurrentItem) {
      blockTodo as BlockTodoClearCurrentItem<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockClearCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (6), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoDeleteItem
    else if (blockTodo is BlockTodoDeleteItem) {
      blockTodo as BlockTodoDeleteItem<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockItemDeletionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (7), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoPrepareFormToCreateItem
    else if (blockTodo is BlockTodoPrepareFormToCreateItem) {
      blockTodo as BlockTodoPrepareFormToCreateItem<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockPrepareFormToCreateItemExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (8), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoQuickItemUpdate
    else if (blockTodo is BlockTodoQuickItemUpdate) {
      blockTodo as BlockTodoQuickItemUpdate<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockQuickItemUpdateExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (9), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoQuickItemCreation
    else if (blockTodo is BlockTodoQuickItemCreation) {
      blockTodo as BlockTodoQuickItemCreation<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockQuickItemCreationExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (10), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockTodoBackendAction
    else if (blockTodo is BlockTodoBackendAction) {
      blockTodo as BlockTodoBackendAction<ID, ITEM, ITEM_DETAIL>;
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockBackendActionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionTodo: blockTodo,
        ),
        info:
            "Block (11), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    //
    // Else
    //
    else {
      return NextExecutionUnit.no(
        debug: debug,
        info:
            "Block (12), ${getClassNameWithoutGenerics(block)}, $blockTodo, dataState: ${blockDataState.toBriefInfo()}. **** TODO ****",
      );
    }
  }

  NextExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NextExecutionUnit next = xFilterModel._getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    if (xFormModel != null) {
      next = xFormModel!._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  // ***************************************************************************
  // ***************************************************************************

  BlockTodoPrepareFormToCreateItem<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockTodoPrepareFormToCreateItem({
    required XBlock<ID, ITEM, ITEM_DETAIL> xBlock,
    required bool initDirty,
    required FormInput? formInput,
  }) {
    final blockTodo = BlockTodoPrepareFormToCreateItem<ID, ITEM, ITEM_DETAIL>(
      initDirty: initDirty,
      formInput: formInput,
    );
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoQuery<ID, ITEM, ITEM_DETAIL> _createAndSetBlockTodoQuery({
    bool isQueryMoreFlow = false,
  }) {
    final blockTodo = BlockTodoQuery<ID, ITEM, ITEM_DETAIL>(
      isQueryMoreFlow: isQueryMoreFlow,
    );
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoDeleteItem<ID, ITEM, ITEM_DETAIL> _createAndSetBlockTodoDeleteItem({
    required ITEM item,
  }) {
    final blockTodo = BlockTodoDeleteItem<ID, ITEM, ITEM_DETAIL>(
      item: item,
    );
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoBackendAction<ID, ITEM, ITEM_DETAIL> _createAndSetBackendAction({
    required BlockBackendAction<ID> action,
  }) {
    final blockTodo =
        BlockTodoBackendAction<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoQuickItemUpdate<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockQuickItemUpdate({
    required BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL> action,
  }) {
    final blockTodo =
        BlockTodoQuickItemUpdate<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoQuickItemCreation<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockQuickItemCreation({
    required BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action,
  }) {
    final blockTodo =
        BlockTodoQuickItemCreation<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoClearCurrentItem<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockTodoClearCurrentItem() {
    final blockTodo = BlockTodoClearCurrentItem<ID, ITEM, ITEM_DETAIL>();
    _executionTodo = blockTodo;
    return blockTodo;
  }

  BlockTodoClearItems<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockTodoClearItems() {
    final blockTodo = BlockTodoClearItems<ID, ITEM, ITEM_DETAIL>();
    _executionTodo = blockTodo;
    return blockTodo;
  }

  void _createAndSetBlockTodoDone({
    required String lastTodoInfo,
  }) {
    _executionTodo = BlockTodoDone<ID, ITEM, ITEM_DETAIL>(
      lastTodoInfo: lastTodoInfo,
    );
  }

  void _createAndSetBlockTodoNull({
    required String lastTodoInfo,
  }) {
    _executionTodo = BlockTodoNull<ID, ITEM, ITEM_DETAIL>(
      lastTodoInfo: lastTodoInfo,
    );
  }

  BlockTodoSetCurrentItem<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockTodoSetCurrentItem({
    required BlockSetCurrentItemDirective setCurrentItemDirective,
    required List<ITEM> newQueriedList,
    required ITEM? inputCandidateCurrItem,
    required bool forceReloadItem,
    required ForceType? forceTypeForForm,
  }) {
    final blockTodo = BlockTodoSetCurrentItem<ID, ITEM, ITEM_DETAIL>(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: newQueriedList,
      inputCandidateCurrItem: inputCandidateCurrItem,
      forceReloadItem: forceReloadItem,
      forceTypeForForm: forceTypeForForm,
    );
    _executionTodo = blockTodo;
    return blockTodo;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printParameters({required bool provideBlockContext}) {
    //
  }

  void printInfoCascade() {
    bool provideBlockContext = block.ui.hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: false,
    );
    String msg = "${getClassName(this)}(${getClassName(block)}"
        " - provideBlockContext: $provideBlockContext"
        " - QryHint: $__qryHint - RefreshItem: $__forceReloadCurrItem";
    print(msg);
    for (XBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }

  String toDebugHtmlString() {
    return " - <b>XBlock (${getClassName(block)})</b>"
        "\n    - <b>qryHint</b>: $queryHint"
        "\n    - <b>blockSyncSessionState</b>: ${block._blockSyncSessionState}"
        "\n    - <b>forceReloadItem</b>: $__forceReloadCurrItem"
        "\n    - <b>blockItemRefreshCondition</b>: ${block._blockItemRefreshCondition}"
        "\n    - <b>xFormModel</b>: $xFormModel";
  }

  @override
  String toString() {
    return "XBlock (${getClassName(block)}) \n"
        "      - qryHint: $queryHint / blockReQryCon: ${block._blockSyncSessionState}\n"
        "      - forceReloadItem: $__forceReloadCurrItem / blockItemRefreshCon: ${block._blockItemRefreshCondition} \n"
        "      - xFormModel: $xFormModel";
  }
}
