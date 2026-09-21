part of '../../core.dart';

class _XShelfExecutionUnitQueue {
  final XShelf xShelf;
  final List<_ShelfMemberExecutionUnit> _mainExecutionUnits = [];
  final List<_ShelfMemberExecutionUnit> _secondaryExecutionUnits = [];

  _XShelfExecutionUnitQueue({required this.xShelf});

  _ShelfMemberExecutionUnit? getNextExecutionUnit() {
    if (_mainExecutionUnits.isEmpty) {
      if (_secondaryExecutionUnits.isNotEmpty) {
        _mainExecutionUnits.addAll(_secondaryExecutionUnits);
        _secondaryExecutionUnits.clear();
      }
    }
    if (_mainExecutionUnits.isEmpty) {
      return null;
    } else {
      return _mainExecutionUnits.removeAt(0);
    }
  }

  bool get isEmpty {
    return _mainExecutionUnits.isEmpty && _secondaryExecutionUnits.isEmpty;
  }

  void addExecutionUnit({
    required _ShelfMemberExecutionUnit executionUnit,
    required bool toMainQueue,
  }) {
    if (toMainQueue) {
      _mainExecutionUnits.add(executionUnit);
    } else {
      _secondaryExecutionUnits.add(executionUnit);
    }
  }

  DebugXRootQueueItem toDebugXRootQueueItem() {
    return DebugXRootQueueItem(
      xShelf: xShelf,
      mainExecutionUnits: _mainExecutionUnits
          .map(
            (exeUnit) => exeUnit.toDebugExecutionUnit(),
          )
          .toList(),
      secondaryExecutionUnits: _secondaryExecutionUnits
          .map(
            (tu) => tu.toDebugExecutionUnit(),
          )
          .toList(),
    );
  }
}
