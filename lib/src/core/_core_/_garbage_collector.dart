part of 'core.dart';

class _GarbageCollector {
  static const _GarbageCollector instance = _GarbageCollector.__();
  const _GarbageCollector.__();

  static bool __isStarted = false;

  void start() async {
    if (__isStarted) return;
    __isStarted = true;

    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      try {
        await _runGarbageCollectionAsync();
      } catch (e, stackTrace) {
        print("[FLUTTER_ARTIST] - GarbageCollector: $e");
        print(stackTrace);
      }
    }
  }

  Future<void> _runGarbageCollectionAsync() async {
    FlutterArtist.storage._unmountOrphanShelves();
  }
}
