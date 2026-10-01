part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _TaskFormModelPatchFormFieldsExecutionUnit<FORM_INPUT extends FormInput>
    extends _ActivityMemberResultedExecutionUnit {
  final XTaskFormModel xTaskFormModel;

  @override
  final FormModelPatchFormFieldsIntent executionIntent;

  _TaskFormModelPatchFormFieldsExecutionUnit({
    required this.xTaskFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelPatchFormFields,
          executionIntent: executionIntent,
        );

  @override
  XActivity get xActivity => xTaskFormModel.xActivity;

  @override
  int get xModuleId => xTaskFormModel.xModuleId;

  @override
  Activity get activity => xTaskFormModel.formModel.task.activity;

  @override
  TaskFormModel get owner => xTaskFormModel.formModel;

  @override
  String getObjectName() {
    return xTaskFormModel.formModel.task.name;
  }
}
