import '../../../core/_core_/core.dart';
import '../../../core/enums/_task_type.dart';

class DebugTaskUnit {
  final int xShelfId;
  final TaskType taskType;
  final Shelf shelf;
  final String taskName;

  DebugTaskUnit({
    required this.xShelfId,
    required this.taskType,
    required this.shelf,
    required this.taskName,
  });
}
