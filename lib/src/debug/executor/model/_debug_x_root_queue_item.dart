import '../../../core/_core_/core.dart';
import '_debug_execution_unit.dart';

class DebugXRootQueueItem {
  final XShelf xShelf;
  final List<DebugExecutionUnit> mainExecutionUnits;
  final List<DebugExecutionUnit> secondaryExecutionUnits;

  DebugXRootQueueItem({
    required this.xShelf,
    required this.mainExecutionUnits,
    required this.secondaryExecutionUnits,
  });

  bool get isEmpty => mainExecutionUnits.isEmpty && secondaryExecutionUnits.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
