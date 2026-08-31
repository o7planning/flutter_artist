part of '../../core.dart';

sealed class ExecutionTodo<PRECHECK,
    EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>> {
  final completer = Completer<EXECUTION_RESULT>();

  Future<EXECUTION_RESULT> get result => completer.future;

  @override
  String toString() {
    return getClassNameWithoutGenerics(this);
  }
}

sealed class FilterModelTodo<PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionTodo<PRECHECK, EXECUTION_RESULT> {
  //
}

// FilterPanel change!
final class FilterModelTodoPanelChange extends FilterModelTodo {
  final Map<String, dynamic> formKeyInstantValuesInUI;

  FilterModelTodoPanelChange({
    required this.formKeyInstantValuesInUI,
  });
}

final class FilterModelTodoLoad extends FilterModelTodo {
  //
}

final class FilterModelTodoDone extends FilterModelTodo {
  //
}
