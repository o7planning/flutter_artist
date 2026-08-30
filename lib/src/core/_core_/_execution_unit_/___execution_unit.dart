part of '../core.dart';

///
/// _ExecutionUnit
///   │
///   ├── _ShelfMemberExecutionUnit
///   │   ├── _BlockClearCurrentExecutionUnit
///   │   ├── _FilterPanelChangeExecutionUnit
///   │   ├── ...
///   │   └── _BlockQueryExecutionUnit
///   │
///   │
///   ├── _ActivityMemberExecutionUnit
///   │   ├── _FlowExecutionUnit
///   │   └── _TaskExecutionUnit
///   │
///   └── _StorageBackendActionExecutionUnit
///
@_ExecutionUnitClassAnnotation()
abstract class _ExecutionUnit {
  final ExecutionUnitType executionUnitType;

  Object get owner;

  _ExecutionUnit({required this.executionUnitType});

  String getObjectName();

  String asDebugExecutionUnit() {
    return executionUnitType.asDebugExecutionUnit(getObjectName());
  }
}
