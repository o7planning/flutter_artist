part of '../core.dart';

class _XShelfTaskUnitQueue {
  final XShelf xShelf;
  final List<_STaskUnit> _mainTaskUnits = [];
  final List<_STaskUnit> _secondaryTaskUnits = [];

  _XShelfTaskUnitQueue({required this.xShelf});

  _STaskUnit? getNextTaskUnit() {
    if (_mainTaskUnits.isEmpty) {
      if (_secondaryTaskUnits.isNotEmpty) {
        _mainTaskUnits.addAll(_secondaryTaskUnits);
        _secondaryTaskUnits.clear();
      }
    }
    if (_mainTaskUnits.isEmpty) {
      return null;
    } else {
      return _mainTaskUnits.removeAt(0);
    }
  }

  bool get isEmpty {
    return _mainTaskUnits.isEmpty && _secondaryTaskUnits.isEmpty;
  }

  void addTaskUnit({required _STaskUnit taskUnit, required bool toMainQueue}) {
    if (toMainQueue) {
      _mainTaskUnits.add(taskUnit);
    } else {
      _secondaryTaskUnits.add(taskUnit);
    }
  }

  DebugXRootQueueItem toDebugXRootQueueItem() {
    return DebugXRootQueueItem(
      xShelf: xShelf,
      mainTaskUnits: _mainTaskUnits
          .map(
            (tu) => tu.toDebugTaskUnit(),
          )
          .toList(),
      secondaryTaskUnits: _secondaryTaskUnits
          .map(
            (tu) => tu.toDebugTaskUnit(),
          )
          .toList(),
    );
  }
}
