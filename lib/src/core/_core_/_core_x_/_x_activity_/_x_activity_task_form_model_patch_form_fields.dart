part of '../../core.dart';

class _XActivityFormModelPatchFormFields extends XActivity {
  _XActivityFormModelPatchFormFields({
    required ActivityFormModel formModel,
  }) : super(
    xActivityType: XActivityType.formModelEnterFields,
    activity: formModel.activity,
  ) {
    //
  }
}
