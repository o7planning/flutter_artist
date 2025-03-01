part of '../flutter_artist.dart';

class ScalarData<
    VALUE extends Object, //
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, FILTER_INPUT, FILTER_CRITERIA> scalar;

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  VALUE? _value;

  VALUE? get value => _value;

  DataState _queryDataState = DataState.pending;

  DataState get queryDataState => _queryDataState;

  // ***************************************************************************
  // ***************************************************************************

  ScalarData(this.scalar);

  // ***************************************************************************
  // ***************************************************************************

  void setToPending() {
    _queryDataState = DataState.pending;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFrom({
    required FILTER_CRITERIA? filterCriteria,
    required VALUE? data,
    required DataState dataState,
  }) {
    _filterCriteria = filterCriteria;
    _value = data;
    _queryDataState = dataState;
  }
}
