part of '../core.dart';

class _StorageNaturalQueryQueue {
  final Map<String, Shelf> _shelfMap = {};

  final int delayMilliseconds = 40;
  bool __locked = false;

  _NaturalQueryTimer? _naturalQueryTimer;

  List<Shelf> getAllRemoveAll() {
    List<Shelf> shelves = [..._shelfMap.values];
    _shelfMap.clear();
    return shelves;
  }

  // LOGIC: #0000
  void addShelf(Shelf shelf) {
    _shelfMap[shelf.name] = shelf;
    //
    if (!__locked) {
      __locked = true;
      _naturalQueryTimer = _NaturalQueryTimer(
          delayInMilliseconds: delayMilliseconds,
          work: () async {
            __locked = false;
            // LOGIC: #0000
            await _executeNaturalQueryQueue();
          });
      _naturalQueryTimer?.start();
    }
  }

  // LOGIC: #0000 (**)
  Future<void> _executeNaturalQueryQueue() async {
    List<Shelf> lazyShelves = getAllRemoveAll();
    if (lazyShelves.isEmpty) {
      return;
    }
    print("\n\n\n@@@@@@@@@@@@@ EXECUTE NATURAL QUERY @@@@@@@@@\n\n");
    for (Shelf lazyShelf in lazyShelves) {
      if (lazyShelf.disposed) {
        continue;
      }
      await lazyShelf._startLoadDataForLazyUIComponentsIfNeed();
    }
  }
}

// *****************************************************************************
// *****************************************************************************

class _NaturalQueryTimer {
  final int delayInMilliseconds;
  final Future<void> Function() work;

  _NaturalQueryTimer({
    required this.delayInMilliseconds,
    required this.work,
  });

  Future<void> start() async {
    await Future.delayed(Duration(milliseconds: delayInMilliseconds));
    //
    await work();
  }
}
