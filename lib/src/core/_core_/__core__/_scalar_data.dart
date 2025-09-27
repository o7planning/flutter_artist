part of '../core.dart';

class _ScalarData<
    VALUE extends Object, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  FILTER_CRITERIA? _filterCriteria;

  _ValueWrap<VALUE> __current = _ValueWrap<VALUE>(id: null, value: null);

  _ValueWrap<VALUE> get current => __current;

  DataState _scalarDataState = DataState.pending;

  PageData<VALUE>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  int _filterCriteriaChangeCount = 0;

  // ***************************************************************************
  // ***************************************************************************

  _ScalarData(this.scalar);

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState scalarDataState}) {
    _scalarDataState = scalarDataState;
    __current = _ValueWrap<VALUE>(id: null, value: null);
    _filterCriteria = null; // ???
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isXCriteriaChanged({
    required FILTER_CRITERIA newFilterCriteria,
  }) {
    if (newFilterCriteria != _filterCriteria) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setToPending() {
    _scalarDataState = DataState.pending;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearValueWithDataState({
    required DataState scalarDataState,
    required bool errorInFilter,
  }) {
    _scalarDataState = scalarDataState;
    if (_scalarDataState == DataState.error) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      if (errorInFilter) {
        __setNewFilterCriteria(null);
      }
    }
    //
    __current = _ValueWrap<VALUE>(id: null, value: null);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFrom({
    required FILTER_CRITERIA? filterCriteria,
    required String? valueId,
    required VALUE? value,
    required DataState dataState,
    required ActionResultState queryResultState,
  }) {
    __setNewFilterCriteria(filterCriteria);
    __current = _ValueWrap<VALUE>(id: valueId, value: value);
    _scalarDataState = dataState;
    _lastQueryResultState = queryResultState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteria(FILTER_CRITERIA? newFilterCriteria) {
    final bool changed = _filterCriteria != newFilterCriteria;
    _filterCriteria = newFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
    }
  }
}
