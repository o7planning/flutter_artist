part of '../../core.dart';

class _XActivityFormViewChange extends XActivity {
  _XActivityFormViewChange({
    required TaskFormModel formModel,
  }) : super(
    xActivityType: XActivityType.formViewChange,
    activity: formModel.activity,
  ) {
    //
  }
}
