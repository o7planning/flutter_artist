part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelLoadFormAnnotation()
@Deprecated("Xoa di")
class _FormModelLoadFormTaskUnitOLD
    extends _ResultedTaskUnit<FormModelDataLoadResult> {
  _XFormModel xFormModel;

  _FormModelLoadFormTaskUnitOLD({
    required this.xFormModel,
  }) : super(
          taskType: TaskType.formModelLoadForm,
          taskResult: FormModelDataLoadResult(),
        );

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



@_TaskUnitClassAnnotation()
@_FormModelLoadFormAnnotation()
class _FormModelLoadFormTaskUnit
    extends _ResultedTaskUnit<FormModelDataLoadResult> {
  _QFormModel xFormModel;

  _FormModelLoadFormTaskUnit({
    required this.xFormModel,
  }) : super(
    taskType: TaskType.formModelLoadForm,
    taskResult: FormModelDataLoadResult(),
  );

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
