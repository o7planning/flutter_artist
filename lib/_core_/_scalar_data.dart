part of '../flutter_artist.dart';

class ScalarData<
    VALUE extends Object,
    SUGGESTED_CRITERIA extends SuggestedCriteria,
    FILTER_CRITERIA extends EmptyFilterCriteria> {
  ///
  /// Owner Scalar.
  ///
  final Scalar<VALUE, SUGGESTED_CRITERIA, FILTER_CRITERIA> scalar;

  bool __isTemporaryMode = false;

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  VALUE? _value;

  VALUE? get value => _value;

  VALUE? __valueBk;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

  DataState __dataStateBk = DataState.pending;

  ScalarData(this.scalar);

  void setToPending() {
    print(" --> Set to pending ${getClassName(scalar)}");
    _dataState = DataState.pending;
  }

  void _updateFrom({
    required FILTER_CRITERIA? filterCriteria,
    required VALUE? data,
    required DataState dataState,
  }) {
    _filterCriteria = filterCriteria;
    _value = data;
    _dataState = dataState;
  }

  void _backup() {
    if (!__isTemporaryMode) {
      __isTemporaryMode = true;
      __dataStateBk = _dataState;
      __valueBk = _value;
    }
  }

  @override
  void _applyNewState() {
    if (__isTemporaryMode) {
      __isTemporaryMode = false;
      __dataStateBk = DataState.pending;
      __valueBk = null;
    }
  }

  @override
  void _restore() {
    if (__isTemporaryMode) {
      __isTemporaryMode = false;
      _dataState = __dataStateBk;
      _value = __valueBk;
    }
  }
}
