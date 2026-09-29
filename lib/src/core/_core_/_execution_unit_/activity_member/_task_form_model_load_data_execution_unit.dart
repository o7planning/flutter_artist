part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_TaskFormModelLoadDataAnnotation()
class _TaskFormModelLoadDataExecutionUnit
    extends _ActivityMemberResultedExecutionUnit<FormModelDataLoadResult> {
  final XTaskFormModel xTaskFormModel;

  @override
  final FormModelDataLoadIntent executionIntent;

  _TaskFormModelLoadDataExecutionUnit({
    required this.xTaskFormModel,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.formModelLoadData,
    executionIntent: executionIntent,
  );

  @override
  XActivity get xActivity => xTaskFormModel.xActivity;

  @override
  int get xActivityId => xTaskFormModel.xActivityId;

  @override
  Activity get activity => xTaskFormModel.formModel.task.activity;

  @override
  TaskFormModel get owner => xTaskFormModel.formModel;

  @override
  String getObjectName() {
    return xTaskFormModel.formModel.task.name;
  }
}