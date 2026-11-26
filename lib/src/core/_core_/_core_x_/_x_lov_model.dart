part of '../core.dart';

/// Runtime execution wrapper for an individual [LovModel] within an [XShelf].
///
/// Coordinates the LOV's directly owned [XFilterModel] and its own query/clear
/// lifecycle without coupling to [Block] hierarchies or [FormModel]s.
class XLovModel<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  int get xModuleId => xShelf.xModuleId;

  String get name => lovModel.name;

  final LovModel<ID, ITEM, FilterPatch, FilterCriteria> lovModel;

  final XFilterModel xFilterModel;

  bool _queried = false;

  bool get queried => _queried;

  LovExecutionIntent<
      ID, //
      ITEM,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  LovExecutionIntent<
      ID, //
      ITEM,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  // Query options:
  QueryHint __queryHint = QueryHint.none;
  QueryType __queryType = QueryType.realQuery;
  ListUpdateStrategy? __listUpdateStrategy;
  Pageable? __pageable;

  QueryHint get queryHint => __queryHint;

  QueryType get queryType => __queryType;

  ListUpdateStrategy? get listUpdateStrategy => __listUpdateStrategy;

  Pageable? get pageable => __pageable;

  bool get isLazy =>
      lovModel.dataState.isPending || lovModel.dataState.isLoadedStale;

  // ***************************************************************************
  // CONSTRUCTOR
  // ***************************************************************************

  /// IMPORTANT: Create via [LovModel._createXLovModel] so runtime generic
  /// parameters `<ID, ITEM>` match the owning [LovModel].
  XLovModel._({
    required this.lovModel,
    required this.xFilterModel,
  });

  // ***************************************************************************
  // PAGINATION & EXECUTION HINTS
  // ***************************************************************************

  Pageable? getWillBeUsedPageable(QueryType queryType) {
    switch (queryType) {
      case QueryType.realQuery:
        return lovModel.config.nativeQueryMode == BlockNativeQueryMode.fullQuery
            ? null
            : (pageable ?? lovModel.config.pageable);
      case QueryType.emptyQuery:
        return lovModel.config.nativeQueryMode == BlockNativeQueryMode.fullQuery
            ? null
            : lovModel._initialPageable;
    }
  }

  void _setQueriedTrue() {
    _queried = true;
  }

  void _setQueriedFalse() {
    _queried = false;
  }

  void resetExecutionHints() {
    __queryHint = QueryHint.none;
  }

  void setReQueryDone() {
    __queryHint = QueryHint.none;
  }

  bool isReQueryDone() {
    return __queryHint == QueryHint.none;
  }

  void setQueryHint(QueryHint queryHint) {
    __queryHint = queryHint;
  }

  void setQueryHintToGreater(QueryHint queryHint) {
    if (__queryHint.isLessThan(queryHint)) {
      __queryHint = queryHint;
    }
  }

  void setOptions({
    required QueryType queryType,
    required ListUpdateStrategy? listUpdateStrategy,
    required Pageable? pageable,
  }) {
    __queryType = queryType;
    __listUpdateStrategy = listUpdateStrategy;
    __pageable = pageable;
  }

  // ***************************************************************************
  // EXECUTION UNIT RESOLUTION
  // ***************************************************************************

  /// Resolves the next execution unit for this LOV, checking its owned
  /// [xFilterModel] first before evaluating the [LovModel] itself.
  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    // Guard: Avoid waking up the LOV's FilterModel when the LOV dialog is not
    // open and no explicit intent or forced query hint targets this LOV.
    final bool hasActiveUi = lovModel.ui.hasLovContext() ||
        (lovModel.filterModel?.ui.hasVisibleViews() ?? false);
    final bool hasPendingWork = hasActiveUi ||
        __queryHint == QueryHint.force ||
        _executionIntent != null ||
        _stashedIntent != null ||
        xFilterModel._executionIntent != null ||
        xFilterModel._stashedIntent != null;

    if (!hasPendingWork) {
      return NxtExecutionUnit.no(
        debug: debug,
        info: "${getClassNameWithoutGenerics(lovModel)} -> hidden & idle",
      );
    }

    // 1. Resolve LOV's own FilterModel first.
    NxtExecutionUnit next = xFilterModel._getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }

    // 2. Resolve LOV's own query/clear unit.
    return __getNextExecutionUnit(debug: debug);
  }

  /// Resolves execution units owned directly by this [LovModel] (excluding FilterModel).
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // 1. Restore stashed intent if the current intent has been consumed.
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = LovNextUnitInput(
      dataState: lovModel.dataState,
      currentIntent: _executionIntent,
      queryHint: __queryHint,
      isVisible: lovModel.ui.hasLovContext(),
      queried: _queried,
      modelName: getClassNameWithoutGenerics(lovModel),
    );

    final output = LovExecutionCalculator.calculate(input);

    // 2. Preserve current intent if displaced by an implicit reload.
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Inject missing Query intent when needed.
    if (output.missingIntent == MissingIntentType.dataLoadOrQuery) {
      final intentToUse = _createAndSetLovExecutionIntentQuery();
      finalDebugInfo = finalDebugInfo.replaceFirst(
        "_executionIntent: $_stashedIntent",
        "_executionIntent: $_stashedIntent --> $intentToUse",
      );
    }

    // 4. Map action to concrete ExecutionUnit.
    switch (output.action) {
      case LovExecutionAction.query:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _LovQueryExecutionUnit<ID, ITEM>(
            xLovModel: this,
            executionIntent: _executionIntent as LovQueryIntent<ID, ITEM>,
          ),
          info: finalDebugInfo,
        );
      case LovExecutionAction.clearItems:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _LovClearItemsExecutionUnit<ID, ITEM>(
            xLovModel: this,
            executionIntent: _executionIntent as LovClearItemsIntent<ID, ITEM>,
          ),
          info: finalDebugInfo,
        );
      case LovExecutionAction.none:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************
  // INTENT FACTORIES
  // ***************************************************************************

  LovQueryIntent<ID, ITEM> _createAndSetLovExecutionIntentQuery({
    bool isQueryMoreFlow = false,
  }) {
    final executionIntent = LovQueryIntent<ID, ITEM>(
      isQueryMoreFlow: isQueryMoreFlow,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  LovClearItemsIntent<ID, ITEM> _createAndSetLovExecutionIntentClearItems() {
    final executionIntent = LovClearItemsIntent<ID, ITEM>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  void _createAndSetLovExecutionIntentDone({
    required String lastIntentInfo,
  }) {
    _executionIntent = LovDoneIntent<ID, ITEM>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  // ***************************************************************************
  // DIAGNOSTICS
  // ***************************************************************************

  void printInfo() {
    final bool hasActiveUI = lovModel.ui.hasLovContext();
    print(
      "${getClassName(this)}(${getClassName(lovModel)}"
      " - hasLovContext: $hasActiveUI - queryHint: $__queryHint)",
    );
  }

  @override
  String toString() {
    return "XLovModel (${getClassName(lovModel)}) - queryHint: $__queryHint";
  }
}
