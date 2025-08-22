import '../../../core/enums/_x_shelf_type.dart';
import '_debug_task_unit.dart';

class DebugXShelfTaskUnitQueue {
  final int xShelfId;
  final String shelfName;
  final XShelfType xShelfType;
  final List<DebugTaskUnit> taskUnits;

  DebugXShelfTaskUnitQueue({
    required this.xShelfId,
    required this.shelfName,
    required this.xShelfType,
    required this.taskUnits,
  });

  bool get isEmpty => taskUnits.isEmpty;

  bool get isNotEmpty => taskUnits.isNotEmpty;
}
