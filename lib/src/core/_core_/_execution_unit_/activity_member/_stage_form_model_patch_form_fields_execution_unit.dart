part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _StageFormModelPatchFormFieldsExecutionUnit<FORM_INPUT extends FormInput>
    extends _ActivityMemberResultedExecutionUnit {
  final XStageFormModel xStageFormModel;

  @override
  final FormModelPatchFormFieldsIntent executionIntent;

  _StageFormModelPatchFormFieldsExecutionUnit({
    required this.xStageFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelPatchFormFields,
          executionIntent: executionIntent,
        );

  @override
  XActivity get xActivity => xStageFormModel.xActivity;

  @override
  int get xModuleId => xStageFormModel.xModuleId;

  @override
  Activity get activity => xStageFormModel.formModel.stage.activity;

  @override
  StageFormModel get owner => xStageFormModel.formModel;

  @override
  String getObjectName() {
    return xStageFormModel.formModel.stage.name;
  }
}
