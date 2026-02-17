part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _FormModelPatchFormFieldsTaskUnit<FORM_INPUT extends FormInput>
    extends _ResultedSTaskUnit {
  XFormModel xFormModel;
  FORM_INPUT formInput;

  _FormModelPatchFormFieldsTaskUnit({
    required this.xFormModel,
    required this.formInput,
  }) : super(taskType: TaskType.formModelPatchFormFields);

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
