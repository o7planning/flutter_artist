import '../../../core/_core_/core.dart';
import '_debug_task_unit.dart';

class DebugXShelfTaskUnitQueue {
  final XShelf xShelf;
  final List<DebugTaskUnit> mainTaskUnits;
  final List<DebugTaskUnit> secondaryTaskUnits;

  DebugXShelfTaskUnitQueue({
    required this.xShelf,
    required this.mainTaskUnits,
    required this.secondaryTaskUnits,
  });

  bool get isEmpty => mainTaskUnits.isEmpty && secondaryTaskUnits.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
