import '_debug_task_unit.dart';

class DebugSubTaskUnitQueue {
  final int subQueueId;
  final List<DebugTaskUnit> taskUnits;

  DebugSubTaskUnitQueue({
    required this.subQueueId,
    required this.taskUnits,
  });
}
