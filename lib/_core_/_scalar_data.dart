part of '../flutter_artist.dart';

class ScalarData<VALUE, SUGGESTED_FILTER_DATA extends SuggestedFilterData,
    FILTER_SNAPSHOT extends FilterSnapshot> {
  final Scalar<VALUE, SUGGESTED_FILTER_DATA, FILTER_SNAPSHOT> scalar;

  bool __isTemporaryMode = false;

  FILTER_SNAPSHOT? _filterSnapshot;

  FILTER_SNAPSHOT? get filterSnapshot => _filterSnapshot;

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
    required FILTER_SNAPSHOT? filterSnapshot,
    required VALUE? data,
    required DataState dataState,
  }) {
    _filterSnapshot = filterSnapshot;
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
