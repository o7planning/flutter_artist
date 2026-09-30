part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_StageFormModelLoadDataAnnotation()
class _StageFormModelLoadDataExecutionUnit
    extends _ActivityMemberResultedExecutionUnit<FormModelDataLoadResult> {
  final XStageFormModel xStageFormModel;

  @override
  final FormModelDataLoadIntent executionIntent;

  _StageFormModelLoadDataExecutionUnit({
    required this.xStageFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelLoadData,
          executionIntent: executionIntent,
        );

  @override
  XActivity get xActivity => xStageFormModel.xActivity;

  @override
  int get xActivityId => xStageFormModel.xActivityId;

  @override
  Activity get activity => xStageFormModel.formModel.stage.activity;

  @override
  StageFormModel get owner => xStageFormModel.formModel;

  @override
  String getObjectName() {
    return xStageFormModel.formModel.stage.name;
  }
}
