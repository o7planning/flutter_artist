part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _StageFormViewChangeExecutionUnit extends _ActivityMemberExecutionUnit {
  XStageFormModel xStageFormModel;

  @override
  final FormModelViewChangeIntent executionIntent;

  _StageFormViewChangeExecutionUnit({
    required this.xStageFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelFormViewChanged,
          executionIntent: executionIntent,
        );

  @override
  XActivity get xActivity => xStageFormModel.xActivity;

  @override
  int get xActivityId => xStageFormModel.xActivityId;

  @override
  Activity get activity => xStageFormModel.formModel.activity;

  @override
  StageFormModel get owner => xStageFormModel.formModel;

  @override
  String getObjectName() {
    return xStageFormModel.formModel.stage.name;
  }
}
