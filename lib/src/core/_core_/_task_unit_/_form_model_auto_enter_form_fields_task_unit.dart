part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelEnterFormFieldsAnnotation()
class _FormModelAutoEnterFormFieldsTaskUnit<
EXTRA_FORM_INPUT extends ExtraFormInput> extends _STaskUnit {
  XFormModel xFormModel;
  EXTRA_FORM_INPUT extraFormInput;

  _FormModelAutoEnterFormFieldsTaskUnit({
    required this.xFormModel,
    required this.extraFormInput,
  }) : super(taskType: TaskType.formModelEnterFormFields);

  @override
  XShelf get xShelf => xFormModel.xShelf;

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
