part of '../core.dart';

class _ScalarData<
    VALUE extends Object, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  XFilterCriteria<FILTER_CRITERIA>? _xFilterCriteria;

  _ScalarValueWrap<VALUE> __current =
      _ScalarValueWrap<VALUE>(id: null, value: null);

  _ScalarValueWrap<VALUE> get current => __current;

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
    __current = _ScalarValueWrap<VALUE>(id: null, value: null);
    _xFilterCriteria = null; // ???
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isXCriteriaChanged({
    required XFilterCriteria<FILTER_CRITERIA> newXFilterCriteria,
  }) {
    if (newXFilterCriteria != _xFilterCriteria) {
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
    __current = _ScalarValueWrap<VALUE>(id: null, value: null);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateData({
    required XFilterCriteria<FILTER_CRITERIA>? xFilterCriteria,
    required String? valueId,
    required VALUE? value,
    required DataState dataState,
    required ActionResultState queryResultState,
  }) {
    __setNewFilterCriteria(xFilterCriteria);
    __current = _ScalarValueWrap<VALUE>(id: valueId, value: value);
    _scalarDataState = dataState;
    _lastQueryResultState = queryResultState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteria(
      XFilterCriteria<FILTER_CRITERIA>? newXFilterCriteria) {
    final bool changed = _xFilterCriteria != newXFilterCriteria;
    _xFilterCriteria = newXFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
    }
  }
}
