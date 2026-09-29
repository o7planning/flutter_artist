part of '../../core.dart';

class _XActivityTaskFormModelPatchFormFields extends XActivity {
  _XActivityTaskFormModelPatchFormFields({
    required TaskFormModel formModel,
  }) : super(
    xActivityType: XActivityType.formModelEnterFields,
    activity: formModel.task.activity,
  ) {
    //
    // IMPORTANT:
    //
    XTask xTask = xTaskMap[formModel.task.name]!;
  }
}
