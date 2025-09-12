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

  String? _valueId;
  VALUE? _value;

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
    _valueId = null;
    _value = null;
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
    _value = null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFrom({
    required FILTER_CRITERIA? filterCriteria,
    required String? valueId,
    required VALUE? value,
    required DataState dataState,
  }) {
    __setNewFilterCriteria(filterCriteria);
    _valueId = valueId;
    _value = value;
    _scalarDataState = dataState;
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
