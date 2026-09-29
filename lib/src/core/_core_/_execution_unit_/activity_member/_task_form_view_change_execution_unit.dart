part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _TaskFormViewChangeExecutionUnit extends _ActivityMemberExecutionUnit {
  XTaskFormModel xTaskFormModel;

  @override
  final FormModelViewChangeIntent executionIntent;

  _TaskFormViewChangeExecutionUnit({
    required this.xTaskFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelFormViewChanged,
          executionIntent: executionIntent,
        );

  @override
  XActivity get xActivity => xTaskFormModel.xActivity;

  @override
  int get xActivityId => xTaskFormModel.xActivityId;

  @override
  Activity get activity => xTaskFormModel.formModel.activity;

  @override
  TaskFormModel get owner => xTaskFormModel.formModel;

  @override
  String getObjectName() {
    return xTaskFormModel.formModel.task.name;
  }
}
