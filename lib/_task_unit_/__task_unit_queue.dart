part of '../flutter_artist.dart';

final _taskUnitQueue = _TaskUnitQueue();

class _TaskUnitQueue {
  final List<_TaskUnit> _taskUnits = [];

  bool get isEmpty {
    return _taskUnits.isEmpty;
  }

  bool hasNext() {
    return _taskUnits.isNotEmpty;
  }

  _TaskUnit? getNextTaskUnit() {
    if (_taskUnits.isEmpty) {
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
    // if (taskUnit is _FormModelLoadFormTaskUnit) {
    //   if (!contains(taskUnit.getTaskUnitId())) {
    //     _taskUnits.add(taskUnit);
    //   }
    // } else {
    //   _taskUnits.add(taskUnit);
    // }
    _taskUnits.add(taskUnit);
  }

  @override
  String toString() {
    return _taskUnits.toString();
  }
}
