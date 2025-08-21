part of '../core.dart';

class _TaskUnitQueue {
  int __maxXShelfId = -1;

  // Sorted Key Map.
  final __splayTreeMap = SplayTreeMap<int, _SubTaskUnitQueue>();

  bool get isEmpty {
    for (_SubTaskUnitQueue sub in __splayTreeMap.values) {
      if (!sub.isEmpty) {
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

  _TaskUnit? getNextTaskUnit() {
    while (true) {
      int? xShelfId = __splayTreeMap.firstKey();
      if (xShelfId == null) {
        return null;
      }
      _SubTaskUnitQueue subQueue = __splayTreeMap[xShelfId]!;
      _TaskUnit? taskUnit = subQueue.getNextTaskUnit();
      if (taskUnit == null) {
        __splayTreeMap.remove(xShelfId);
        continue;
      }
      return taskUnit;
    }
  }

  void addTaskUnit(_TaskUnit taskUnit) {
    final int? executingXShelfId = FlutterArtist.executor.executingXShelfId;
    //
    if (executingXShelfId != null) {
      if (taskUnit.xShelfId < executingXShelfId) {
        throw FatalAppError(
          errorMessage:
              "Development Error - taskUnit.xShelfId must be greater or equals than executingXShelfId.",
        );
      }
    }
    if (taskUnit.xShelfId <= __maxXShelfId) {
      _SubTaskUnitQueue? subQueue = __splayTreeMap[taskUnit.xShelfId];
      if (subQueue == null) {
        throw FatalAppError(
          errorMessage:
              "Development Error - taskUnit.xShelfId not found in Queue.",
        );
      }
      subQueue.addTaskUnit(taskUnit);
    }
    // taskUnit.xShelfId > __maxXShelfId
    else {
      __maxXShelfId = taskUnit.xShelfId;
      _SubTaskUnitQueue subQueue = _SubTaskUnitQueue();
      __splayTreeMap[taskUnit.xShelfId] = subQueue;
      subQueue.addTaskUnit(taskUnit);
    }
  }

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

// *****************************************************************************

class _SubTaskUnitQueue {
  final List<_TaskUnit> _taskUnits = [];

  _TaskUnit? getNextTaskUnit() {
    if (_taskUnits.isEmpty) {
      return null;
    } else {
      return _taskUnits.removeAt(0);
    }
  }

  bool get isEmpty {
    return _taskUnits.isEmpty;
  }

  void addTaskUnit(_TaskUnit taskUnit) {
    _taskUnits.add(taskUnit);
  }

  DebugSubTaskUnitQueue toDebugSubTaskUnitQueue({required int subQueueId}) {
    return DebugSubTaskUnitQueue(
      subQueueId: subQueueId,
      taskUnits: _taskUnits
          .map(
            (tu) => tu.toDebugTaskUnit(),
          )
          .toList(),
    );
  }
}
