part of '../../core.dart';

sealed class FormModelExecutionIntent<
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

final class FormModelSaveIntent
    extends FormModelExecutionIntent<BlockFormSavePrecheck, BlockFormSaveResult> {
  FormModelSaveIntent();
}

// FormView change!
final class FormModelViewChangeIntent extends FormModelExecutionIntent<
    FormModelViewChangedPrecheck, //
    FormModelViewChangedResult> {
  final Map<String, dynamic> formKeyInstantValuesInUI;

  FormModelViewChangeIntent({
    required this.formKeyInstantValuesInUI,
  });
}

final class FormModelDataLoadIntent extends FormModelExecutionIntent<
    FormModelDataLoadPrecheck, //
    FormModelDataLoadResult> {
  //
}

final class FormModelDoneIntent extends FormModelExecutionIntent {
  //
}

final class FormModelPatchFormFieldsIntent<FORM_INPUT extends FormInput>
    extends FormModelExecutionIntent<
        FormModelPatchFormFieldsPrecheck, //
        FormModelPatchFormFieldsResult> {
  final FORM_INPUT formInput;

  FormModelPatchFormFieldsIntent({required this.formInput});
}
