part of '../core.dart';

class _LazyUiComponentTriggerQueue {
  final Map<String, Shelf> _shelfMap = {};
  final Map<String, Activity> _activityMap = {};

  final int delayMilliseconds = 40;
  bool __locked = false;

  _NaturalQueryTimer? _naturalQueryTimer;

  List<Shelf> getAllLazyShelvesAndRemoveAll() {
    List<Shelf> shelves = [..._shelfMap.values];
    _shelfMap.clear();
    return shelves;
  }

  List<Activity> getAllLazyActivitiesAndRemoveAll() {
    List<Activity> activities = [..._activityMap.values];
    _activityMap.clear();
    return activities;
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
            await _executeNaturalQueue();
          });
      _naturalQueryTimer?.start();
    }
  }

  // LOGIC: #0000
  void addActivity(Activity activity) {
    _activityMap[activity.name] = activity;
    //
    if (!__locked) {
      __locked = true;
      _naturalQueryTimer = _NaturalQueryTimer(
          delayInMilliseconds: delayMilliseconds,
          work: () async {
            __locked = false;
            // LOGIC: #0000
            await _executeNaturalQueue();
          });
      _naturalQueryTimer?.start();
    }
  }

  // LOGIC: #0000 (**)
  Future<void> _executeNaturalQueue() async {
    List<Shelf> lazyShelves = getAllLazyShelvesAndRemoveAll().toList();
    List<Activity> lazyActivities = getAllLazyActivitiesAndRemoveAll().toList();

    if (lazyShelves.isEmpty && lazyActivities.isEmpty) {
      return;
    }
    //
    var executionTrace = FlutterArtist.codeFlowLogger._addNaturalUIEvent(
      ownerClassInstance: this,
    );
    if (lazyShelves.isNotEmpty) {
      executionTrace.addInfo(
        codeId: "#00000",
        shortDesc:
            "Just detected some <b>UI Components</b> that have just been displayed. "
            "This will trigger a query execution on the associated <b>Shelves</b>:\n"
            " - ${lazyShelves.map((s) => debugObjHtml(s)).join(", ")}",
        tipDocument: TipDocument.naturalQuery,
      );
    }
    if (lazyActivities.isNotEmpty) {
      executionTrace.addInfo(
        codeId: "#00001",
        shortDesc:
            "Just detected some <b>UI Components</b> that have just been displayed. "
            "This will trigger an execution on the associated <b>Activities</b>:\n"
            " - ${lazyActivities.map((s) => debugObjHtml(s)).join(", ")}",
        tipDocument: TipDocument.naturalQuery,
      );
    }

    for (Shelf lazyShelf in lazyShelves) {
      if (lazyShelf.markedAsOrphan) {
        // Still continue.
      }
      executionTrace.addInfo(
        codeId: "#00100",
        shortDesc:
            "Start checking lazy model-components of ${debugObjHtml(lazyShelf)}...",
      );
      await lazyShelf._dispatchNaturalQuery(
        executionTrace: executionTrace,
      );
    }
    for (Activity lazyActivity in lazyActivities) {
      if (lazyActivity.markedAsOrphan) {
        // Still continue.
      }
      executionTrace.addInfo(
        codeId: "#00200",
        shortDesc:
            "Start checking lazy model-components of ${debugObjHtml(lazyActivity)}...",
      );
      await lazyActivity._dispatchNaturalExecution(
        executionTrace: executionTrace,
      );
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
