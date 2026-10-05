part of '../../core.dart';

class _XActivityFormModelPatchFormFields extends XActivity {
  _XActivityFormModelPatchFormFields({
    required WorkNodeFormModel formModel,
  }) : super(
          xActivityType: XActivityType.formModelEnterFields,
          activity: formModel.activity,
        ) {
    //
  }
}
