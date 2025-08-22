part of '../core.dart';

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

  DebugSubTaskUnitQueue toDebugSubTaskUnitQueue( ) {
    return DebugSubTaskUnitQueue(
      taskUnits: _taskUnits
          .map(
            (tu) => tu.toDebugTaskUnit(),
          )
          .toList(),
    );
  }
}
