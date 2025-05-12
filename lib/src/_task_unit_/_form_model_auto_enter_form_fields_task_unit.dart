part of '../../flutter_artist.dart';

class _FormModelAutoEnterFormFieldsTaskUnit<
EXTRA_FORM_INPUT extends ExtraFormInput> extends _TaskUnit {
  _XFormModel xFormModel;
  EXTRA_FORM_INPUT extraFormInput;

  _FormModelAutoEnterFormFieldsTaskUnit({
    required this.xFormModel,
    required this.extraFormInput,
  }) : super(taskType: TaskType.formModelEnterFormFields);

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.block.shelf;

  @override
  FormModel get owner => xFormModel.formModel;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
