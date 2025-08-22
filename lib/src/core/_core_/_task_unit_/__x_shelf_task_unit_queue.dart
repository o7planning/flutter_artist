part of '../core.dart';

class _XShelfTaskUnitQueue {
  final XShelf xShelf;
  final List<_TaskUnit> _taskUnits = [];

  _XShelfTaskUnitQueue({required this.xShelf});

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

  DebugXShelfTaskUnitQueue toDebugXShelfTaskUnitQueue() {
    return DebugXShelfTaskUnitQueue(
      xShelfId: xShelf.xShelfId,
      shelfName: xShelf.shelf.name,
      xShelfType: xShelf.xShelfType,
      taskUnits: _taskUnits
          .map(
            (tu) => tu.toDebugTaskUnit(),
          )
          .toList(),
    );
  }
}
