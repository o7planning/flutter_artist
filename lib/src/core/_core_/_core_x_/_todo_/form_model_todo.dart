part of '../../core.dart';

sealed class FormModelTodo<PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionTodo<PRECHECK, EXECUTION_RESULT> {
  //
}

final class FormModelTodoSave
    extends FormModelTodo<BlockFormSavePrecheck, FormSaveResult> {
  FormModelTodoSave();
}

// FormView change!
final class FormModelTodoViewChange extends FormModelTodo {
  final Map<String, dynamic> formKeyInstantValuesInUI;

  FormModelTodoViewChange({
    required this.formKeyInstantValuesInUI,
  });
}

final class FormModelTodoLoad extends FormModelTodo {
  //
}

final class FormModelTodoDone extends FormModelTodo {
  //
}
