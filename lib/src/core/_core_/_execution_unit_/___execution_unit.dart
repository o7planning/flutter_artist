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
  final ExecutionIntent executionIntent;

  Object get owner;

  _ExecutionUnit({
    required this.executionUnitType,
    required this.executionIntent,
  });

  String getObjectName();

  String asDebugExecutionUnit() {
    return executionUnitType.asDebugExecutionUnit(getObjectName());
  }
}

class NxtExecutionUnit {
  final _ExecutionUnit? executionUnit;
  final bool yes;
  final String info;

  NxtExecutionUnit.yes({
    required this.executionUnit,
    required this.info,
    required bool debug,
  }) : yes = true {
    PrintUtils.debug(debug, " --> [$yes] - $info");
  }

  NxtExecutionUnit.no({
    required this.info,
    required bool debug,
  })  : yes = false,
        executionUnit = null {
    PrintUtils.debug(debug, " --> [$yes] - $info");
  }
}
