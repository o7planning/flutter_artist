part of '../flutter_artist.dart';

class NonBlockData<D extends Object, S extends FilterSnapshot> {
  final NonBlock<D, S> nonBlock;

  bool __isTemporaryMode = false;

  S? _currentFilterSnapshot;

  S? get currentFilterSnapshot => _currentFilterSnapshot;

  D? _data;

  D? get data => _data;

  D? __dataBk;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

  DataState __dataStateBk = DataState.pending;

  NonBlockData(this.nonBlock);

  void _updateFrom({
    required S? filterSnapshot,
    required D? data,
    required DataState dataState,
  }) {
    _currentFilterSnapshot = filterSnapshot;
    _data = data;
    _dataState = dataState;
  }

  void _backup() {
    if (!__isTemporaryMode) {
      __isTemporaryMode = true;
      __dataStateBk = _dataState;
      __dataBk = _data;
    }
  }

  @override
  void _applyNewState() {
    if (__isTemporaryMode) {
      __isTemporaryMode = false;
      __dataStateBk = DataState.pending;
      __dataBk = null;
    }
  }

  @override
  void _restore() {
    if (__isTemporaryMode) {
      __isTemporaryMode = false;
      _dataState = __dataStateBk;
      _data = __dataBk;
    }
  }
}
