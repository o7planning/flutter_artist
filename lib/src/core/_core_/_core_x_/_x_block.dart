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

  BlockSetCurrentItemIntent<
      ID, //
      ITEM,
      ITEM_DETAIL>? _pendingSetCurrentItemIntent;

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

  bool currentItemReloadedInSession = false;
  bool _queried = false;

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

  // Options:

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

  void _setQueriedTrue() {
    _queried = true;
  }

  void _setQueriedFalse() {
    _queried = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasQryHintInTreeBranchAndNotProcessed() {
    if (__qryHint == QryHint.force) {
      return true;
    }
    //
    for (XBlock child in childXBlocks) {
      if (child.hasQryHintInTreeBranchAndNotProcessed()) {
        return true;
      }
    }
    return false;
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

  // Block only (Not find in FilterModel, FormModel).
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    final bool isVisibleX =
    block.ui.hasActiveUiComponent(alsoCheckChildren: true);
    final blockDataState = block.dataState;
    final itemDataState = block.blockItemDataState;
    final executionIntent = _executionIntent;

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (blockDataState.isNone) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "Block (1.1), ${getClassNameWithoutGenerics(
            block)}, intent: $executionIntent, "
            "dataState: ${blockDataState
            .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}",
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (blockDataState.isPending) {
      final bool shouldQuery =
          (__qryHint == QryHint.force || isVisibleX) && !_queried;

      if (shouldQuery) {
        // Ensure executionIntent is QueryIntent to refresh stale dataset before any item manipulation
        final BlockQueryIntent<ID, ITEM, ITEM_DETAIL> intentToUse;
        if (executionIntent is BlockQueryIntent<ID, ITEM, ITEM_DETAIL>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetBlockExecutionIntentQuery();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: intentToUse,
          ),
          info:
          "Block (2.1), ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $intentToUse, "
              "dataState: ${blockDataState
              .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}, "
              "qryHint: $__qryHint, isVisibleX: $isVisibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Block (2.2), ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $executionIntent, "
              "dataState: ${blockDataState
              .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}, "
              "qryHint: $__qryHint, isVisibleX: $isVisibleX",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (blockDataState.isStale) {
      final bool shouldQuery =
          (__qryHint == QryHint.force || isVisibleX) && !_queried;

      if (shouldQuery) {
        // Ensure executionIntent is QueryIntent to refresh stale dataset before any item manipulation
        final BlockQueryIntent<ID, ITEM, ITEM_DETAIL> intentToUse;
        if (executionIntent is BlockQueryIntent<ID, ITEM, ITEM_DETAIL>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetBlockExecutionIntentQuery();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: intentToUse,
          ),
          info:
          "Block 3.1, ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $intentToUse, "
              "dataState: ${blockDataState
              .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}, "
              "qryHint: $__qryHint, isVisibleX: $isVisibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Block 3.2, ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $executionIntent, "
              "dataState: ${blockDataState
              .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}, "
              "qryHint: $__qryHint, isVisibleX: $isVisibleX",
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FRESH
    // =========================================================================
    else if (blockDataState.isFresh) {
      // IN: blockDataState.isFresh
      // 4.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is BlockDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Block (4.2.1), ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $executionIntent, "
              "dataState: ${blockDataState.toBriefInfo()}",
        );
      }

      // IN: blockDataState.isFresh
      // 4.1. Force re-query explicitly requested
      if (__qryHint == QryHint.force) {
        // Reuse caller-provided QueryIntent if already attached to preserve completer hooks
        final BlockQueryIntent<ID, ITEM, ITEM_DETAIL> intentToUse;
        if (executionIntent is BlockQueryIntent<ID, ITEM, ITEM_DETAIL>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetBlockExecutionIntentQuery();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: intentToUse,
          ),
          info:
          "Block (4.1), ${getClassNameWithoutGenerics(
              block)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${blockDataState
              .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}, "
              "qryHint: $__qryHint, isVisibleX: $isVisibleX",
        );
      }
      // IN: blockDataState.isFresh
      // 4.2. Handle existing Execution Intents
      if (executionIntent != null) {
        if (executionIntent is BlockDoneIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Block (4.2.1), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent is BlockNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Block (4.2.2), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent is BlockQueryIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockQueryExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.3), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>) {
          var intentToRun = executionIntent;
          //
          if (_pendingSetCurrentItemIntent != null) {
            intentToRun = _pendingSetCurrentItemIntent!;
            _pendingSetCurrentItemIntent = null; // Consume
            _executionIntent = intentToRun;
          }
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: intentToRun,
            ),
            info:
            "Block (4.2.4), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockClearCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.5), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockItemDeletionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.6), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _BlockPrepareFormToCreateItemExecutionUnit<ID,
                ITEM,
                ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.7), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockQuickItemUpdateExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.8), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockQuickItemCreationExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.9), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockBackendActionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: executionIntent,
            ),
            info:
            "Block (4.2.10), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Block (4.2.11), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: $executionIntent, "
                "dataState: ${blockDataState.toBriefInfo()}",
          );
        }
      }
      // IN: blockDataState.isFresh
      // executionIntent == null
      else {
        // IN: blockDataState.isFresh
        // IN: executionIntent == null
        // 4.3. Automatic synchronization based on Item Data State when no intent is active
        if (itemDataState.isNone) {
          if (block.formModel != null &&
              block.formModel!.formMode == FormMode.creation) {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
              "Block (4.3.1), ${getClassNameWithoutGenerics(
                  block)}, _executionIntent: null, "
                  "dataState: ${blockDataState
                  .toBriefInfo()}, itemDataState: ${itemDataState
                  .toBriefInfo()}",
            );
          }
          bool itemVisibleX = block.ui
              .hasActiveUiComponentItemRepresentative(alsoCheckChildren: true);
          if (block.itemCount > 0 && itemVisibleX) {
            final setItemIntent =
            _createAndSetBlockExecutionIntentSetCurrentItem(
              setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
              newQueriedList: [],
              inputCandidateCurrItem: null,
              forceReloadItem: true,
              forceTypeForForm: null,
            );
            return NxtExecutionUnit.yes(
              debug: debug,
              executionUnit:
              _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
                xBlock: this,
                executionIntent: setItemIntent,
              ),
              info:
              "Block (4.3.2.1), ${getClassNameWithoutGenerics(
                  block)}, _executionIntent: null -> $setItemIntent, "
                  "dataState: ${blockDataState
                  .toBriefInfo()}, itemDataState: ${itemDataState
                  .toBriefInfo()}",
            );
          } else {
            return NxtExecutionUnit.no(
              debug: debug,
              info:
              "Block (4.3.2.2), ${getClassNameWithoutGenerics(
                  block)}, _executionIntent: null, "
                  "dataState: ${blockDataState
                  .toBriefInfo()}, itemDataState: ${itemDataState
                  .toBriefInfo()}",
            );
          }
        }
        // IN: blockDataState.isFresh
        // IN: executionIntent == null
        else if (itemDataState.isFresh) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Block (4.3.2.1), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: null, "
                "dataState: ${blockDataState
                .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}",
          );
        }
        // IN: blockDataState.isFresh
        // IN: executionIntent == null
        else if (itemDataState.isStale) {
          final setItemIntent = _createAndSetBlockExecutionIntentSetCurrentItem(
            setCurrentItemDirective:
            BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
            newQueriedList: [],
            inputCandidateCurrItem: null,
            forceReloadItem: true,
            forceTypeForForm: null,
          );
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _BlockSetItemAsCurrentExecutionUnit<ID, ITEM, ITEM_DETAIL>(
              xBlock: this,
              executionIntent: setItemIntent,
            ),
            info:
            "Block (4.3.3), ${getClassNameWithoutGenerics(
                block)}, _executionIntent: null -> $setItemIntent, "
                "dataState: ${blockDataState
                .toBriefInfo()}, itemDataState: ${itemDataState.toBriefInfo()}",
          );
        }
        // IN: blockDataState.isFresh
        // IN: executionIntent == null
        else {
          throw UnimplementedError(
            "Unhandled itemDataState in Fresh block: ${itemDataState
                .toBriefInfo()}",
          );
        }
      }
    }

    // =========================================================================
    // 5. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
      "Block (5.1), ${getClassNameWithoutGenerics(
          block)}, intent: $executionIntent, "
          "dataState: ${blockDataState.toBriefInfo()}",
    );
  }

  // ***************************************************************************
  // ***************************************************************************

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
    required FormForceType? forceTypeForForm,
  }) {
    final executionIntent = BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: newQueriedList,
      inputCandidateCurrItem: inputCandidateCurrItem,
      forceReloadItem: forceReloadItem,
      forceTypeForForm: forceTypeForForm,
    );
    _executionIntent = executionIntent;
    _pendingSetCurrentItemIntent ??= executionIntent;
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
