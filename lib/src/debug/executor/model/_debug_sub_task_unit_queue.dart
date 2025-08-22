import '_debug_task_unit.dart';

int __subQueueId = 0;

class DebugSubTaskUnitQueue {
  final int subQueueId = __subQueueId++;

  final List<DebugTaskUnit> taskUnits;

  DebugSubTaskUnitQueue({
    required this.taskUnits,
  });

  bool get isEmpty => taskUnits.isEmpty;

  bool get isNotEmpty => taskUnits.isNotEmpty;
}
