import '../../../core/_core_/core.dart';
import '../../../core/enums/_task_type.dart';

class DebugTaskUnit {
  final XShelf xShelf;
  final TaskType taskType;
  final String taskName;

  DebugTaskUnit({
    required this.xShelf,
    required this.taskType,
    required this.taskName,
  });
}
