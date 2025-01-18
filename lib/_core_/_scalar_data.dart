part of '../flutter_artist.dart';

class ScalarData<V, S extends FilterSnapshot> {
  final Scalar<V, S> scalar;

  bool __isTemporaryMode = false;

  S? _filterSnapshot;

  S? get filterSnapshot => _filterSnapshot;

  V? _value;

  V? get value => _value;

  V? __valueBk;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

  DataState __dataStateBk = DataState.pending;

  ScalarData(this.scalar);

  void setToPending() {
    print(" --> Set to pending ${getClassName(scalar)}");
    _dataState = DataState.pending;
  }

  void _updateFrom({
    required S? filterSnapshot,
    required V? data,
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
