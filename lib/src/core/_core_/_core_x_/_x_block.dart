part of '../core.dart';

class XBlock<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xShelfId => xShelf.xShelfId;

  BlockExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

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

  ListUpdateStrategy? __listUpdateStrategy;
  SuggestedSelection? __suggestedSelection;
  BlockAfterQueryDirective? __afterQueryDirective;
  Pageable? __pageable;

  // TODO: Delete ít! ??????????????????????????????????????????????????????????

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

  BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic>?
      _pendingPredecessorResult;

  void stagePredecessorResult(
      BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic> result) {
    _pendingPredecessorResult = result;
  }

  void attachToPredecessorIfAny(
      BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL, dynamic> currentResult) {
    if (_pendingPredecessorResult != null) {
      _pendingPredecessorResult!.linkNextResult(currentResult);
      _pendingPredecessorResult = null;
    }
  }

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

  bool isReQueryDone() {
    return __qryHint == QryHint.none;
  }

  bool needToReQuery() {
    return __qryHint == QryHint.force;
  }

  void setReQueryDone() {
    __qryHint = QryHint.none;
  }

  void resetExecutionHints() {
    __qryHint = QryHint.none;
    __forceReloadCurrItem = false;
    __candidateCurrItem = null;
    __currItemInternalEVT = null;
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
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    final bool isVisibleX =
        block.ui.hasActiveUiComponent(alsoCheckChildren: true);
    final blockDataState = block.dataState;
    final itemDataState = block.blockItemDataState;
    if (_executionIntent == null) {
      // (IN _executionIntent = null). dataState = None
      if (blockDataState.isNone) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Block (1.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
              "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. ",
        );
      }
      // (IN _executionIntent = null). dataState = Pending
      else if (blockDataState.isPending) {
        if (__qryHint == QryHint.force || isVisibleX) {
          _createAndSetBlockExecutionIntentQuery();
          //
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              executionIntent: _executionIntent as BlockQueryIntent,
            ),
            info:
                "Block (1.2.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Block (1.2.2), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
      }
      // (IN _executionIntent = null). dataState = Stale.
      else if (blockDataState.isStale) {
        if (__qryHint == QryHint.force || isVisibleX) {
          _createAndSetBlockExecutionIntentQuery();
          //
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              executionIntent: _executionIntent as BlockQueryIntent,
            ),
            info:
                "Block (1.3.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Block (1.3.2), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
      }
      // (IN _executionIntent = null). dataState = Fresh.
      else if (blockDataState.isFresh) {
        if (__qryHint == QryHint.force) {
          _createAndSetBlockExecutionIntentQuery();
          //
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit(
              xBlock: this,
              executionIntent: _executionIntent as BlockQueryIntent,
            ),
            info:
                "Block (1.4.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                " qryHint: $__qryHint, isVisibleX: $isVisibleX",
          );
        }
        // (IN _executionIntent = null). dataState = Fresh.
        // __qryHint != QryHint.force
        else {
          if (itemDataState.isNone) {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
                  "Block (1.4.1.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                  "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                  " qryHint: $__qryHint, isVisibleX: $isVisibleX",
            );
          } else if (itemDataState.isFresh) {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
                  "Block (1.4.1.2), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                  "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                  " qryHint: $__qryHint, isVisibleX: $isVisibleX",
            );
          } else if (itemDataState.isPending) {
            _createAndSetBlockExecutionIntentSetCurrentItem(
              setCurrentItemDirective: BlockSetCurrentItemDirective
                  .setAnItemAsCurrentIfNeed, // TODO: Hardcode?
              newQueriedList: [],
              inputCandidateCurrItem: null,
              forceReloadItem: true,
              forceTypeForForm: null,
            );
            //
            return NxtExecutionUnit.yes(
              debug: debug,
              executionUnit:
                  _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
                xBlock: this,
                executionIntent: _executionIntent
                    as BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>,
              ),
              info:
                  "Block (1.4.1.3), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                  "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                  " qryHint: $__qryHint, isVisibleX: $isVisibleX",
            );
          } else if (itemDataState.isStale) {
            _createAndSetBlockExecutionIntentSetCurrentItem(
              setCurrentItemDirective: BlockSetCurrentItemDirective
                  .setAnItemAsCurrentIfNeed, // TODO: Hardcode?
              newQueriedList: [],
              inputCandidateCurrItem: null,
              forceReloadItem: true,
              forceTypeForForm: null,
            );
            //
            return NxtExecutionUnit.yes(
              debug: debug,
              executionUnit:
                  _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
                xBlock: this,
                executionIntent: _executionIntent
                    as BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>,
              ),
              info:
                  "Block (1.4.1.4), ${getClassNameWithoutGenerics(block)}, _executionIntent: $_executionIntent, "
                  "dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}. "
                  " qryHint: $__qryHint, isVisibleX: $isVisibleX",
            );
          } else {
            throw UnimplementedError(
                "Never run (XBlock) - 1, dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}.");
          }
        }
      }
      // (IN _executionIntent = null). dataState = OTHERS
      else {
        throw UnimplementedError(
            "Never run (XBlock) - 2, dataState: ${blockDataState.toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}.");
      }
    }
    //
    // _executionIntent != null.
    //
    final executionIntent = _executionIntent!;
    // BlockDoneIntent
    if (executionIntent is BlockDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Block (2), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockNullIntent
    else if (executionIntent is BlockNullIntent) {
      if (blockDataState.isNone) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Block (3.1), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isPending) {
        _createAndSetBlockExecutionIntentQuery();
        //
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit(
            xBlock: this,
            executionIntent: _executionIntent as BlockQueryIntent,
          ),
          info:
              "Block (3.2), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isStale) {
        _createAndSetBlockExecutionIntentQuery();
        //
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit(
            xBlock: this,
            executionIntent: _executionIntent as BlockQueryIntent,
          ),
          info:
              "Block (3.3), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else if (blockDataState.isFresh) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Block (3.4), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
        );
      } else {
        throw UnimplementedError("Never run (XBlock) - 2");
      }
    }
    // BlockQueryIntent
    else if (executionIntent is BlockQueryIntent) {
      executionIntent as BlockQueryIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockQueryExecutionUnit(
          xBlock: this,
          executionIntent: _executionIntent as BlockQueryIntent,
        ),
        info:
            "Block (4), ${getClassNameWithoutGenerics(block)}, _executionIntent: $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockSetCurrentItemIntent
    else if (executionIntent is BlockSetCurrentItemIntent) {
      executionIntent as BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (5), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockClearCurrentItemIntent
    else if (executionIntent is BlockClearCurrentItemIntent) {
      executionIntent as BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockClearCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (6), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockDeleteItemIntent
    else if (executionIntent is BlockDeleteItemIntent) {
      executionIntent as BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockItemDeletionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (7), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockPrepareFormToCreateItemIntent
    else if (executionIntent is BlockPrepareFormToCreateItemIntent) {
      executionIntent
          as BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockPrepareFormToCreateItemExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (8), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockQuickItemUpdateIntent
    else if (executionIntent is BlockQuickItemUpdateIntent) {
      executionIntent as BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockQuickItemUpdateExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (9), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockQuickItemCreationIntent
    else if (executionIntent is BlockQuickItemCreationIntent) {
      executionIntent as BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit:
            _BlockQuickItemCreationExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (10), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    // BlockBackendActionIntent
    else if (executionIntent is BlockBackendActionIntent) {
      executionIntent as BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL>;
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _BlockBackendActionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
          xBlock: this,
          executionIntent: executionIntent,
        ),
        info:
            "Block (11), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. ",
      );
    }
    //
    // Else
    //
    else {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Block (12), ${getClassNameWithoutGenerics(block)}, $executionIntent, dataState: ${blockDataState.toBriefInfo()}. **** TODO ****",
      );
    }
  }

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = xFilterModel._getNextExecutionUnit(debug: debug);
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

  BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentPrepareFormToCreateItem({
    required XBlock<ID, ITEM, ITEM_DETAIL> xBlock,
    required bool initDirty,
    required FormInput? formInput,
  }) {
    final executionIntent =
        BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>(
      initDirty: initDirty,
      formInput: formInput,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockQueryIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentQuery({
    bool isQueryMoreFlow = false,
  }) {
    final executionIntent = BlockQueryIntent<ID, ITEM, ITEM_DETAIL>(
      isQueryMoreFlow: isQueryMoreFlow,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentDeleteItem({
    required ITEM item,
  }) {
    final executionIntent = BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL>(
      item: item,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentDeleteItems({
    required List<ITEM> items,
    required bool stopIfError,
  }) {
    final executionIntent = BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL>(
      items: items,
      stopIfError: stopIfError,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL> _createAndSetBackendAction({
    required BlockBackendAction<ID> action,
  }) {
    final executionIntent =
        BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockQuickItemUpdate({
    required BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL> action,
  }) {
    final executionIntent =
        BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockQuickItemCreation({
    required BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action,
  }) {
    final executionIntent =
        BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>(action: action);
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentClearCurrentItem() {
    final executionIntent =
        BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentClearItems() {
    final executionIntent = BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  void _createAndSetBlockExecutionIntentDone({
    required String lastIntentInfo,
  }) {
    _executionIntent = BlockDoneIntent<ID, ITEM, ITEM_DETAIL>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  void _createAndSetBlockExecutionIntentNull({
    required String lastIntentInfo,
  }) {
    _executionIntent = BlockNullIntent<ID, ITEM, ITEM_DETAIL>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockExecutionIntentSetCurrentItem({
    required BlockSetCurrentItemDirective setCurrentItemDirective,
    required List<ITEM> newQueriedList,
    required ITEM? inputCandidateCurrItem,
    required bool forceReloadItem,
    required ForceType? forceTypeForForm,
  }) {
    final executionIntent = BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: newQueriedList,
      inputCandidateCurrItem: inputCandidateCurrItem,
      forceReloadItem: forceReloadItem,
      forceTypeForForm: forceTypeForForm,
    );
    _executionIntent = executionIntent;
    return executionIntent;
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

  // String toDebugHtmlString() {
  //   return " - <b>XBlock (${getClassName(block)})</b>"
  //       "\n    - <b>qryHint</b>: $queryHint"
  //       "\n    - <b>blockSyncSessionState</b>: ${block._blockSyncSessionState}"
  //       "\n    - <b>forceReloadItem</b>: $__forceReloadCurrItem"
  //       "\n    - <b>blockItemRefreshCondition</b>: ${block._blockItemRefreshCondition}"
  //       "\n    - <b>xFormModel</b>: $xFormModel";
  // }

  // @override
  // String toString() {
  //   return "XBlock (${getClassName(block)}) \n"
  //       "      - qryHint: $queryHint / blockReQryCon: ${block._blockSyncSessionState}\n"
  //       "      - forceReloadItem: $__forceReloadCurrItem / blockItemRefreshCon: ${block._blockItemRefreshCondition} \n"
  //       "      - xFormModel: $xFormModel";
  // }
}
