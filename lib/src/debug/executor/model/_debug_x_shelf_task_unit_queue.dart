import '../../../core/_core_/core.dart';
import '_debug_task_unit.dart';

class DebugXShelfTaskUnitQueue {
  final XShelf xShelf;
  final List<DebugTaskUnit> taskUnits;

  DebugXShelfTaskUnitQueue({
    required this.xShelf,
    required this.taskUnits,
  });

  bool get isEmpty => taskUnits.isEmpty;

  bool get isNotEmpty => taskUnits.isNotEmpty;
}
