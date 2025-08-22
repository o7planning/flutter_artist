part of '../core.dart';

class _TaskUnitQueue {
  int __maxXShelfId = -1;

  // LinkedHashMap<String, XShelf>()
  final __xShelfMapQueue = <String, XShelf>{};

  // Sorted Key Map.
  final __splayTreeMap = SplayTreeMap<int, _SubTaskUnitQueue>();

  // bool get isEmpty {
  //   for (_SubTaskUnitQueue sub in __splayTreeMap.values) {
  //     if (!sub.isEmpty) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  bool get isEmpty {
    for (XShelf xShelf in __xShelfMapQueue.values) {
      if (!xShelf.isEmptyTask()) {
        return false;
      }
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    // TODO: Remove.
  }

  bool hasNext() {
    return isNotEmpty;
  }

  // _TaskUnit? getNextTaskUnit() {
  //   while (true) {
  //     int? xShelfId = __splayTreeMap.firstKey();
  //     if (xShelfId == null) {
  //       return null;
  //     }
  //     _SubTaskUnitQueue subQueue = __splayTreeMap[xShelfId]!;
  //     _TaskUnit? taskUnit = subQueue.getNextTaskUnit();
  //     if (taskUnit == null) {
  //       __splayTreeMap.remove(xShelfId);
  //       continue;
  //     }
  //     return taskUnit;
  //   }
  // }

  _TaskUnit? getNextTaskUnit() {
    while (true) {
      String? firstShelfName = __xShelfMapQueue.keys.firstOrNull;
      if (firstShelfName == null) {
        return null;
      }
      XShelf firstXShelf = __xShelfMapQueue[firstShelfName]!;
      if (firstXShelf.isEmptyTask()) {
        __xShelfMapQueue.remove(firstShelfName);
        continue;
      }
      return firstXShelf.getNextTaskUnit()!;
    }
  }

  void _addXShelf(XShelf xShelf) {
    __xShelfMapQueue[xShelf.shelf.name] = xShelf;
  }

  // void addTaskUnit(_TaskUnit taskUnit) {
  //   final int? executingXShelfId = FlutterArtist.executor.executingXShelfId;
  //   //
  //   if (executingXShelfId != null) {
  //     if (taskUnit.xShelfId < executingXShelfId) {
  //       throw FatalAppError(
  //         errorMessage:
  //             "Development Error - taskUnit.xShelfId must be greater or equals than executingXShelfId.",
  //       );
  //     }
  //   }
  //   if (taskUnit.xShelfId <= __maxXShelfId) {
  //     _SubTaskUnitQueue? subQueue = __splayTreeMap[taskUnit.xShelfId];
  //     if (subQueue == null) {
  //       throw FatalAppError(
  //         errorMessage:
  //             "Development Error - taskUnit.xShelfId not found in Queue.",
  //       );
  //     }
  //     subQueue.addTaskUnit(taskUnit);
  //   }
  //   // taskUnit.xShelfId > __maxXShelfId
  //   else {
  //     __maxXShelfId = taskUnit.xShelfId;
  //     _SubTaskUnitQueue subQueue = _SubTaskUnitQueue();
  //     __splayTreeMap[taskUnit.xShelfId] = subQueue;
  //     subQueue.addTaskUnit(taskUnit);
  //   }
  // }

  DebugTaskUnitQueue toDebugTaskUnitQueue() {
    return DebugTaskUnitQueue(
      subQueues: __splayTreeMap.entries
          .map((entry) =>
              entry.value.toDebugSubTaskUnitQueue(subQueueId: entry.key))
          .toList(),
    );
  }

  @override
  String toString() {
    return "TaskUnitQueue: $__splayTreeMap";
  }
}
