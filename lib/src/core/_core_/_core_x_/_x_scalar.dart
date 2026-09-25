part of '../core.dart';

class XScalar<ID extends Comparable, VALUE extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  bool _queried = false;

  final Scalar<ID, VALUE, FilterInput, FilterCriteria> scalar;

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

  int get xShelfId => xShelf.xShelfId;

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
    final bool isVisibleX = scalar.ui.hasVisibleViews(includeDescendants: true);
    final scalarDataState = scalar.dataState;
    final executionIntent = _executionIntent;

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (scalarDataState.isNone) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "Scalar (1.1), ${getClassNameWithoutGenerics(
            scalar)}, _executionIntent: $executionIntent, "
            "dataState: ${scalarDataState.toBriefInfo()}",
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (scalarDataState.isPending) {
      final bool shouldQuery =
          (__queryHint == QueryHint.force || isVisibleX) && !_queried;

      if (shouldQuery) {
        // Enforce QueryIntent to resolve pending or stale state before executing other actions
        final ScalarQueryIntent<ID, VALUE> intentToUse;
        if (executionIntent is ScalarQueryIntent<ID, VALUE>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetScalarExecutionIntentQuery();
        }
        // IN: DATA STATE = PENDING
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarQueryExecutionUnit(
            xScalar: this,
            executionIntent: intentToUse,
          ),
          info:
          "Scalar (2.1), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${scalarDataState
              .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
        );
      }
      // IN: DATA STATE = PENDING
      // !shouldQuery
      else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Scalar (2.2), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $executionIntent, "
              "dataState: ${scalarDataState
              .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (scalarDataState.isStale) {
      final bool shouldQuery =
          (__queryHint == QueryHint.force || isVisibleX) && !_queried;

      if (shouldQuery) {
        // Enforce QueryIntent to resolve pending or stale state before executing other actions
        final ScalarQueryIntent<ID, VALUE> intentToUse;
        if (executionIntent is ScalarQueryIntent<ID, VALUE>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetScalarExecutionIntentQuery();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarQueryExecutionUnit(
            xScalar: this,
            executionIntent: intentToUse,
          ),
          info:
          "Scalar (3.1), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $intentToUse, "
              "dataState: ${scalarDataState
              .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Scalar (3.2), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $executionIntent, "
              "dataState: ${scalarDataState
              .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FRESH
    // =========================================================================
    else if (scalarDataState.isFresh) {
      // IN: scalarDataState.isFresh
      // 4.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is ScalarDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Scalar (4.0), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $executionIntent, "
              "dataState: ${scalarDataState.toBriefInfo()}",
        );
      }

      // 4.1. Force re-query explicitly requested
      if (__queryHint == QueryHint.force) {
        // Reuse caller-provided QueryIntent if already attached to preserve completer hooks
        final ScalarQueryIntent<ID, VALUE> intentToUse;
        if (executionIntent is ScalarQueryIntent<ID, VALUE>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetScalarExecutionIntentQuery();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ScalarQueryExecutionUnit(
            xScalar: this,
            executionIntent: intentToUse,
          ),
          info:
          "Scalar (4.1), ${getClassNameWithoutGenerics(
              scalar)}, _executionIntent: $intentToUse, "
              "dataState: ${scalarDataState
              .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
        );
      }

      // 4.2. Handle active execution intents
      if (executionIntent != null) {
        if (executionIntent is ScalarDoneIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Scalar (4.2.1), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        } else if (executionIntent is ScalarNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Scalar (4.2.2), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        } else if (executionIntent is ScalarQueryIntent<ID, VALUE>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _ScalarQueryExecutionUnit(
              xScalar: this,
              executionIntent: executionIntent,
            ),
            info:
            "Scalar (4.2.3), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        } else if (executionIntent
        is ScalarLoadExtraDataQuickActionIntent<ID, VALUE, dynamic>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit:
            _ScalarLoadExtraDataQuickActionExecutionUnit<ID, VALUE, Object>(
              xScalar: this,
              executionIntent: executionIntent
              as ScalarLoadExtraDataQuickActionIntent<ID, VALUE, Object>,
            ),
            info:
            "Scalar (4.2.4), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        } else if (executionIntent is ScalarClearIntent<ID, VALUE>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _ScalarClearExecutionUnit<ID, VALUE>(
              xScalar: this,
              executionIntent: executionIntent,
            ),
            info:
            "Scalar (4.2.5), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Scalar (4.2.6), ${getClassNameWithoutGenerics(
                scalar)}, _executionIntent: $executionIntent, "
                "dataState: ${scalarDataState.toBriefInfo()}",
          );
        }
      }

      // IN: scalarDataState.isFresh
      // 4.3. Idle state when data is fresh and no intent is active
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "Scalar (4.3), ${getClassNameWithoutGenerics(
            scalar)}, _executionIntent: null, "
            "dataState: ${scalarDataState
            .toBriefInfo()}, queryHint: $__queryHint, isVisibleX: $isVisibleX",
      );
    }

    // =========================================================================
    // 5. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
      "Scalar (5.1), ${getClassNameWithoutGenerics(
          scalar)}, _executionIntent: $executionIntent, "
          "dataState: ${scalarDataState.toBriefInfo()}",
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
        "${getClassName(this)}(${getClassName(
        scalar)} - UiActive: $hasActiveUI - queryHint: $queryHint)";
    print(msg);
  }

  String toDebugHtmlString() {
    return " - <b>XScalar (${getClassName(
        scalar)})</b> - <b>queryHint</b>: $queryHint";
  }

  @override
  String toString() {
    return "XScalar (${getClassName(scalar)})  - queryHint: $queryHint";
  }
}
