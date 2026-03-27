part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormModelLoadDataAnnotation()
class _FormModelLoadDataTaskUnit
    extends _ResultedSTaskUnit<FormModelDataLoadResult> {
  XFormModel xFormModel;

  _FormModelLoadDataTaskUnit({
    required this.xFormModel,
  }) : super(
          taskType: TaskType.formModelLoadData,
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
