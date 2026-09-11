part of '../core.dart';

class _ScalarData<
    ID extends Comparable,
    VALUE extends Identifiable<ID>, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<ID, VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  FilterCriteriaSnapshot<FILTER_CRITERIA>? _filterCriteriaSnapshot;

  _ScalarValueWrap<ID, VALUE> __current =
      _ScalarValueWrap<ID, VALUE>(id: null, value: null);

  _ScalarValueWrap<ID, VALUE> get current => __current;

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
    __current = _ScalarValueWrap<ID, VALUE>(id: null, value: null);
    _filterCriteriaSnapshot = null; // ???
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isFilterCriteriaSnapshotChanged({
    required FilterCriteriaSnapshot<FILTER_CRITERIA> newFilterCriteriaSnapshot,
  }) {
    if (newFilterCriteriaSnapshot != _filterCriteriaSnapshot) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setScalarDataState({
    required ScalarDataState newScalarDataState,
  }) {
    _scalarDataState = newScalarDataState;
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
      scalar._resetBlockSyncSessionState(executionTrace: null);
    }
    // OLD Code: _scalarDataState == DataState.error
    if (hasError) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      if (errorInFilter) {
        __setNewFilterCriteriaSnapshot(newXFilterCriteria: null);
      }
    }

    __current = _ScalarValueWrap<ID, VALUE>(id: null, value: null);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateData({
    required FilterCriteriaSnapshot<FILTER_CRITERIA>? filterCriteriaSnapshot,
    required ID? valueId,
    required VALUE? value,
    required ScalarDataState dataState,
    required ActionResultState queryResultState,
  }) {
    __setNewFilterCriteriaSnapshot(newXFilterCriteria: filterCriteriaSnapshot);
    __current = _ScalarValueWrap<ID, VALUE>(id: valueId, value: value);
    _scalarDataState = dataState;
    _lastQueryResultState = queryResultState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteriaSnapshot({
    required FilterCriteriaSnapshot<FILTER_CRITERIA>? newXFilterCriteria,
  }) {
    final bool changed = _filterCriteriaSnapshot != newXFilterCriteria;
    _filterCriteriaSnapshot = newXFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
    }
  }
}
