import '../../../core/enums/execution_unit_type.dart';

class DebugExecutionUnit {
  final ExecutionUnitType executionUnitType;
  final String taskName;

  DebugExecutionUnit({
    required this.executionUnitType,
    required this.taskName,
  });
}
