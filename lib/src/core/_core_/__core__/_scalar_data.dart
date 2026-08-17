part of '../core.dart';

class _ScalarData<
    VALUE extends Object, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  FilterCriteriaMappedValue<FILTER_CRITERIA>? _filterCriteriaMappedValue;

  _ScalarValueWrap<VALUE> __current =
      _ScalarValueWrap<VALUE>(id: null, value: null);

  _ScalarValueWrap<VALUE> get current => __current;

  late ScalarDataState _scalarDataState;

  // OLD Code: _scalarDataState == DataState.error
  bool get hasError {
    // TODO: Hardcode.
    return false;
  }

  PageData<VALUE>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  int _filterCriteriaChangeCount = 0;

  // ***************************************************************************
  // ***************************************************************************

  _ScalarData(this.scalar) {
    _scalarDataState =
        scalar.isRoot ? ScalarDataStatePending() : ScalarDataStateNone();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateStateAfterQueryError({
    required ScalarDataState newScalarDataState,
  }) {
    _lastQueryResultState = ActionResultState.fail;
    _scalarDataState = newScalarDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required ScalarDataState scalarDataState}) {
    _scalarDataState = scalarDataState;
    __current = _ScalarValueWrap<VALUE>(id: null, value: null);
    _filterCriteriaMappedValue = null; // ???
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isFilterCriteriaMappedValueChanged({
    required FilterCriteriaMappedValue<FILTER_CRITERIA>
        newFilterCriteriaMappedValue,
  }) {
    if (newFilterCriteriaMappedValue != _filterCriteriaMappedValue) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setToPending() {
    _scalarDataState = ScalarDataStatePending();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearValueWithDataState({
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    _scalarDataState = scalarDataState;
    if (resetSyncSessionState) {
      scalar._resetSyncSessionState(executionTrace: null);
    }
    // OLD Code: _scalarDataState == DataState.error
    if (hasError) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      if (errorInFilter) {
        __setNewFilterCriteriaMappedValue(newXFilterCriteria: null);
      }
    }

    __current = _ScalarValueWrap<VALUE>(id: null, value: null);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateData({
    required FilterCriteriaMappedValue<FILTER_CRITERIA>?
        filterCriteriaMappedValue,
    required String? valueId,
    required VALUE? value,
    required ScalarDataState dataState,
    required ActionResultState queryResultState,
  }) {
    __setNewFilterCriteriaMappedValue(
        newXFilterCriteria: filterCriteriaMappedValue);
    __current = _ScalarValueWrap<VALUE>(id: valueId, value: value);
    _scalarDataState = dataState;
    _lastQueryResultState = queryResultState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteriaMappedValue({
    required FilterCriteriaMappedValue<FILTER_CRITERIA>? newXFilterCriteria,
  }) {
    final bool changed = _filterCriteriaMappedValue != newXFilterCriteria;
    _filterCriteriaMappedValue = newXFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
    }
  }
}
