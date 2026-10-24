part of '../core.dart';

class XScalar<ID extends Comparable, VALUE extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  bool _queried = false;

  final Scalar<ID, VALUE, FilterInput, FilterCriteria> scalar;

  ScalarExecutionIntent? _stashedIntent;

  ScalarExecutionIntent<
      ID, //
      VALUE,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  bool get isLazy {
    return scalar.dataState.isPending || scalar.dataState.isStale;
  }

  final XFilterModel xFilterModel;

  XScalar get rootXScalar {
    if (parentXScalar == null) {
      return this;
    }
    return parentXScalar!.rootXScalar;
  }

  late final XScalar? parentXScalar;
  final List<XScalar> childXScalars = [];

  List<XScalar> getDescendantXScalars({required bool sameFilterOnly}) {
    final List<XScalar> ret = [];
    final thisFm = scalar.registeredOrDefaultFilterModel;
    for (XScalar childXScalar in childXScalars) {
      FilterModel fmc = childXScalar.scalar.registeredOrDefaultFilterModel;
      if (!sameFilterOnly || (sameFilterOnly && fmc == thisFm)) {
        ret.add(childXScalar);
      }
      ret.addAll(
        childXScalar.getDescendantXScalars(sameFilterOnly: sameFilterOnly),
      );
    }
    return ret;
  }

  QueryHint __queryHint = QueryHint.none;

  bool isRoot() {
    return parentXScalar == null;
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

  bool affectByFilterInput = false;

  String get name => scalar.name;

  int get xModuleId => xShelf.xModuleId;

  final ScalarQueryResult queryResult = ScalarQueryResult(precheck: null);

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XScalar, use 'scalar._createXScalar' method
  /// to have the same Generics Parameters with the scalar.
  ///
  XScalar._({
    required this.scalar,
    required this.xFilterModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  void _setQueriedTrue() {
    _queried = true;
  }

  void _setQueriedFalse() {
    _queried = false;
  }

  // ***************************************************************************

  QueryHint get queryHint {
    return __queryHint;
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
  }) {
    __queryType = queryType;
  }

  // ***************************************************************************
  // ***************************************************************************

  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // 1. Restore stashed intent if the current intent is null.
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent as ScalarExecutionIntent<
          ID, //
          VALUE,
          dynamic,
          ExecutionUnitResult<dynamic>>;
      _stashedIntent = null;
    }

    final input = ScalarNextUnitInput(
      dataState: scalar.dataState,
      currentIntent: _executionIntent,
      queryHint: __queryHint,
      isVisible: scalar.ui.hasVisibleViews(includeDescendants: true),
      queried: _queried,
      modelName: getClassNameWithoutGenerics(scalar),
    );

    final output = ScalarExecutionCalculator.calculate(input);

    // 2. _stashedIntent
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    // 3. Add new Intent if missing
    if (output.missingIntent == MissingIntentType.dataLoadOrQuery) {
      _createAndSetScalarExecutionIntentQuery();
    }

    // 4. Returns an executable Unit
    switch (output.action) {
      case ScalarExecutionAction.query:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarQueryExecutionUnit(
            xScalar: this,
            executionIntent: _executionIntent as ScalarQueryIntent<ID, VALUE>,
          ),
          info: output.debugInfo,
        );
      case ScalarExecutionAction.loadExtraData:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarLoadExtraDataQuickActionExecutionUnit(
            xScalar: this,
            executionIntent: _executionIntent
                as ScalarLoadExtraDataQuickActionIntent<ID, VALUE, Object>,
          ),
          info: output.debugInfo,
        );
      case ScalarExecutionAction.clear:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarClearExecutionUnit(
            xScalar: this,
            executionIntent: _executionIntent as ScalarClearIntent<ID, VALUE>,
          ),
          info: output.debugInfo,
        );
      case ScalarExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: output.debugInfo,
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
    return next;
  }

  // ***************************************************************************

  ScalarQueryIntent<ID, VALUE> _createAndSetScalarExecutionIntentQuery() {
    final executionIntent = ScalarQueryIntent<ID, VALUE>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  void _createAndSetScalarExecutionIntentDone({
    required String lastIntentInfo,
  }) {
    _executionIntent = ScalarDoneIntent<ID, VALUE>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  // ***************************************************************************

  ScalarLoadExtraDataQuickActionIntent
      _createAndSetScalarExecutionIntentLoadExtraDataQuickAction<
          DATA extends Object>({
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
  }) {
    final executionIntent =
        ScalarLoadExtraDataQuickActionIntent<ID, VALUE, DATA>(
      action: action,
      afterQuickAction: afterQuickAction,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  ScalarClearIntent _createAndSetScalarExecutionIntentClear() {
    final executionIntent = ScalarClearIntent<ID, VALUE>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    bool hasActiveUI = scalar.ui.hasVisibleViews();
    String msg =
        "${getClassName(this)}(${getClassName(scalar)} - UiActive: $hasActiveUI - queryHint: $queryHint)";
    print(msg);
  }

  String toDebugHtmlString() {
    return " - <b>XScalar (${getClassName(scalar)})</b> - <b>queryHint</b>: $queryHint";
  }

  @override
  String toString() {
    return "XScalar (${getClassName(scalar)})  - queryHint: $queryHint";
  }
}
