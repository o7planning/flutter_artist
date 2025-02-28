part of '../flutter_artist.dart';

final _taskUnitQueue = _TaskUnitQueue();

class _TaskUnitQueue {
  final List<_TaskUnit> _taskUnits = [];

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

  void addTaskUnit(_TaskUnit taskUnit) {
    _taskUnits.add(taskUnit);
  }
}
