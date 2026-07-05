part of '../core.dart';

class _GarbageCollector {
  _GarbageCollector();

  bool _running = false;
  Future<void>? _currentRun;

  Future<void> runOnce() {
    if (_running) {
      return _currentRun!;
    }
    _running = true;

    final future = Future.sync(() {
      FlutterArtist.storage.collectGarbage();
    });

    _currentRun = future.whenComplete(() {
      _running = false;
      _currentRun = null;
    });
    return future;
  }
}
