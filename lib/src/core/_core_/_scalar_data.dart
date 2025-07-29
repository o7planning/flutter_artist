part of '../_fa_core.dart';

class _ScalarData<
    VALUE extends Object, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  FILTER_CRITERIA? _filterCriteria;

  VALUE? _value;

  DataState _queryDataState = DataState.pending;

  // ***************************************************************************
  // ***************************************************************************

  _ScalarData(this.scalar);

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({required DataState queryDataState}) {
    _queryDataState = queryDataState;
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
    _queryDataState = DataState.pending;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFrom({
    required FILTER_CRITERIA? filterCriteria,
    required VALUE? value,
    required DataState dataState,
  }) {
    _filterCriteria = filterCriteria;
    _value = value;
    _queryDataState = dataState;
  }
}
