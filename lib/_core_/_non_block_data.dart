part of '../flutter_artist.dart';

class NonBlockData<D extends Object, S extends FilterSnapshot> {
  final NonBlock<D, S> nonBlock;

  S? _currentFilterSnapshot;

  S? get currentFilterSnapshot => _currentFilterSnapshot;

  D? _data;

  D? get data => _data;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

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
}
