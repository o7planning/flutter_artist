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
    List<Shelf> lazyShelves =
        getAllRemoveAll().where((s) => !s.disposed).toList();

    if (lazyShelves.isEmpty) {
      return;
    }
    //
    var masterFlowItem = FlutterArtist.codeFlowLogger._addNaturalUIEvent(
      ownerClassInstance: this,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#00000",
      shortDesc:
          "Just detected some <b>UI Components</b> that have just been displayed. "
          "This will trigger a query execution on the associated <b>Shelves</b>:\n"
          " - ${lazyShelves.map((s) => _debugObjHtml(s)).join(", ")}",
      tipDocument: TipDocument.naturalQuery,
    );
    for (Shelf lazyShelf in lazyShelves) {
      if (lazyShelf.disposed) {
        continue;
      }
      masterFlowItem._addLineFlowItem(
        codeId: "#00100",
        shortDesc:
            "Start checking lazy model-components of ${_debugObjHtml(lazyShelf)}...",
      );
      await lazyShelf._startLoadDataForLazyUIComponentsIfNeed(masterFlowItem);
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
