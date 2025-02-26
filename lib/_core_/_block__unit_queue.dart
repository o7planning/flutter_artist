part of '../flutter_artist.dart';

final _unitQueue = _BlockUnitQueue();

enum TaskUnitName {
  query,
  select,
  delete;
}

class _TaskUnit {
  TaskUnitName taskUnitName;
  _XBlock xBlock;

  _TaskUnit({
    required this.xBlock,
    required this.taskUnitName,
  });

  void printInfo() {
    print(
        ">>>>> EXECUTE TaskUnit: $taskUnitName - Block: ${xBlock.block.name}");
  }
}

class _BlockUnitQueue {
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
