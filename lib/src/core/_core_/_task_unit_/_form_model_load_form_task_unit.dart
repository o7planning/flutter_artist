part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelLoadFormAnnotation()
class _FormModelLoadFormTaskUnit
    extends _ResultedTaskUnit<FormModelDataLoadResult> {
  XFormModel xFormModel;

  _FormModelLoadFormTaskUnit({
    required this.xFormModel,
  }) : super(
          taskType: TaskType.formModelLoadForm,
          taskResult: FormModelDataLoadResult(),
        );

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
