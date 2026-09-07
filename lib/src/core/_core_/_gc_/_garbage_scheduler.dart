part of '../core.dart';

class _GarbageScheduler {
  Timer? _timer;

  _GarbageScheduler();

  void start() {
    _timer ??= Timer.periodic(
      FlutterArtist.appConfig.garbageCollectionInterval,
      (_) {
        FlutterArtist.garbageCollector.runOnce();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
