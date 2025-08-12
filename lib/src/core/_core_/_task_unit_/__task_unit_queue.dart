part of '../core.dart';

class _SubTaskUnitQueue {
  final List<_TaskUnit> _taskUnits = [];

  _TaskUnit? getNextTaskUnit() {
    if (_taskUnits.isEmpty) {
    } else {
      return _taskUnits.removeAt(0);
    }
  }

  bool get isEmpty {
    return _taskUnits.isEmpty;
  }
}

class _TaskUnitQueue {
  // Sorted Key Map.
  final SplayTreeMap<int, _SubTaskUnitQueue> _map =
      SplayTreeMap<int, _SubTaskUnitQueue>();

  final List<_TaskUnit> _secondaryQueue = [];
  final List<_TaskUnit> _taskUnits = [];

  bool get isEmpty {
    for (_SubTaskUnitQueue sub in _map.values) {
      if (!sub.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    _taskUnits.clear();
    _secondaryQueue.clear();
  }

  bool hasNext() {
    return isNotEmpty;
  }

  _TaskUnit? getNextTaskUnit() {
    if (_taskUnits.isEmpty) {
      if (_secondaryQueue.isNotEmpty) {
        return _secondaryQueue.removeAt(0);
      }
      return null;
    } else {
      return _taskUnits.removeAt(0);
    }
  }

  bool contains(String id) {
    for (_TaskUnit tu in _taskUnits) {
      if (tu.getTaskUnitId() == id) {
        return true;
      }
    }
    return false;
  }

  void addTaskUnit(_TaskUnit taskUnit) {
    final int? executingXShelfId = FlutterArtist.executor.executingXShelfId;
    //
    if (executingXShelfId != null) {
      if (taskUnit.xShelfId > executingXShelfId) {
        _secondaryQueue.add(taskUnit);
      } else if (taskUnit.xShelfId == executingXShelfId) {
        _taskUnits.add(taskUnit);
      } else {
        print("Ignore TaskUnit: $taskUnit");
        // Ignore this TaskUnit.
      }
    } else {
      _taskUnits.add(taskUnit);
    }
  }

  @override
  String toString() {
    return "_taskUnits: $_taskUnits, _secondaryQueue: $_secondaryQueue";
  }
}
