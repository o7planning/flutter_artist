part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelSaveFormAnnotation()
class _FormModelSaveFormTaskUnit extends _ResultedTaskUnit<FormSaveResult> {
  _QFormModel xFormModel;

  _FormModelSaveFormTaskUnit({
    required this.xFormModel,
  }) : super(
          taskType: TaskType.formModelSaveForm,
          taskResult: FormSaveResult(precheck: null),
        );



  @override
  _QShelf get xShelf => xFormModel.xShelf;


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
