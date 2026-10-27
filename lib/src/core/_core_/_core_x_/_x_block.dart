part of '../core.dart';

class XBlock<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xModuleId => xShelf.xModuleId;

  BlockExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  BlockExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  final _recentLoadedItemMap = <ID, _BlockCurrentData<ID, ITEM, ITEM_DETAIL>>{};

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      CreationPreset,
      FormInput> block;

  XBlock get rootXBlock {
    if (parentXBlock == null) {
      return this;
    }
    return parentXBlock!.rootXBlock;
  }

  bool _queried = false;

  late final XBlock? parentXBlock;
  final List<XBlock> childXBlocks = [];

  final XFilterModel xFilterModel;
  final XBlockCurrentItemModel xBlockCurrentItemModel;

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

  QueryHint __queryHint = QueryHint.none;
  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  ListUpdateStrategy? __listUpdateStrategy;
  SuggestedSelection? __suggestedSelection;
  BlockAfterQueryDirective? __afterQueryDirective;
  Pageable? __pageable;

  // TODO: Delete ít! ??????????????????????????????????????????????????????????
  final queryResult = BlockQueryResult._();

  // ***************************************************************************

  QueryHint get queryHint => __queryHint;

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
            : block._blockData._emptyPageable;
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
    required this.xBlockCurrentItemModel,
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

  bool hasQueryHintInTreeBranchAndNotProcessed() {
    if (__queryHint == QueryHint.force) {
      return true;
    }
    //
    for (XBlock child in childXBlocks) {
      if (child.hasQueryHintInTreeBranchAndNotProcessed()) {
        return true;
      }
    }
    return false;
  }

  bool isRoot() {
    return parentXBlock == null;
  }

  bool isReQueryDone() {
    return __queryHint == QueryHint.none;
  }

  bool needToReQuery() {
    return __queryHint == QueryHint.force;
  }

  void setReQueryDone() {
    __queryHint = QueryHint.none;
  }

  void resetExecutionHints() {
    __queryHint = QueryHint.none;
  }

  void setQueryHint(QueryHint queryHint) {
    __queryHint = queryHint;
  }

  void setQueryHintToGreater(QueryHint queryHint) {
    if (__queryHint.isLessThan(queryHint)) {
      __queryHint = queryHint;
    }
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
    _recentLoadedItemMap[itemId] = _BlockCurrentData(
      id: itemId,
      item: item,
      itemDetail: itemDetail,
    );
  }

  _BlockCurrentData? _getRecentLoadedItem({required ID itemId}) {
    return _recentLoadedItemMap[itemId];
  }

  // ***************************************************************************
  // ***************************************************************************

  // Block only (Not find in FilterModel, BlockCurrentItemModel).
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // Restore the stashed intent if the current intent is null.
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    // 1. Prepare Input.
    final input = BlockNextUnitInput(
      dataState: block.dataState,
      currentIntent: _executionIntent,
      queryHint: __queryHint,
      isVisible: block.ui.hasVisibleViews(includeDescendants: true),
      queried: _queried,
      modelName: getClassNameWithoutGenerics(block),
    );

    // 2. Calculate Output
    final output = BlockExecutionCalculator.calculate(input);

    // 3. Handling and storing Intent if it is overwritten
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 4. Inject a new Intent if it is missing.
    if (output.missingIntent == MissingIntentType.dataLoadOrQuery) {
      final intentToUse = _createAndSetBlockExecutionIntentQuery();
      finalDebugInfo = finalDebugInfo.replaceFirst(
        "_executionIntent: $_stashedIntent",
        "_executionIntent: $_stashedIntent --> $intentToUse",
      );
    }

    // 5. Map Action to Execution Unit
    switch (output.action) {
      case BlockExecutionAction.query:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockQueryExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent:
                _executionIntent as BlockQueryIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.clearItems:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockClearItemsExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.deleteItem:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockItemDeletionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.deleteItems:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit:
              _BlockMultiItemDeletionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.quickItemUpdate:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit:
              _BlockQuickItemUpdateExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.quickItemCreation:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit:
              _BlockQuickItemCreationExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.backendAction:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit:
              _BlockBackendActionExecutionUnit<ID, ITEM, ITEM_DETAIL>(
            xBlock: this,
            executionIntent: _executionIntent
                as BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
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
    return xBlockCurrentItemModel._getNextExecutionUnit(debug: debug);
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
  //     _createAndSetBlockExecutionIntentClearCurrentItem() {
  //   final executionIntent =
  //       BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>();
  //   _executionIntent = executionIntent;
  //   return executionIntent;
  // }

  // BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>
  //     _createAndSetBlockExecutionIntentPrepareFormToCreateItem({
  //   required XBlock<ID, ITEM, ITEM_DETAIL> xBlock,
  //   required bool initDirty,
  //   required FormInput? formInput,
  // }) {
  //   final executionIntent =
  //       BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>(
  //     initDirty: initDirty,
  //     formInput: formInput,
  //   );
  //   _executionIntent = executionIntent;
  //   return executionIntent;
  // }

  // BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
  //     _createAndSetBlockExecutionIntentSetCurrentItem({
  //   required BlockSetCurrentItemDirective setCurrentItemDirective,
  //   required List<ITEM> newQueriedList,
  //   required ITEM? inputCandidateCurrItem,
  //   required bool forceReloadItem,
  //   required FormLoadHint? formLoadHint,
  // }) {
  //   final executionIntent = BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>(
  //     setCurrentItemDirective: setCurrentItemDirective,
  //     newQueriedList: newQueriedList,
  //     inputCandidateCurrItem: inputCandidateCurrItem,
  //     forceReloadItem: forceReloadItem,
  //     formLoadHint: formLoadHint,
  //   );
  //   _executionIntent = executionIntent;
  //   _pendingSetCurrentItemIntent ??= executionIntent;
  //   return executionIntent;
  // }

  // ***************************************************************************
  // ***************************************************************************

  void printInfoCascade() {
    bool provideItemsContext = block.ui.hasBlockContext(
      includeDescendants: false,
    );
    String msg = "${getClassName(this)}(${getClassName(block)}"
        " - provideItemsContext: $provideItemsContext"
        " - QueryHint: $__queryHint";
    print(msg);
    for (XBlock xBlock in childXBlocks) {
      xBlock.printInfoCascade();
    }
  }
}
