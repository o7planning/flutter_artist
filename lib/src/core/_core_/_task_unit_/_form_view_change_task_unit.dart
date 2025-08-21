part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _FormViewChangeTaskUnit extends _TaskUnit {
  XFormModel xFormModel;

  _FormViewChangeTaskUnit({
    required this.xFormModel,
  }) : super(taskType: TaskType.formModelFormViewChanged);

  @override
  XShelf get xShelf => xFormModel.xShelf;

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.shelf;

  @override
  FormModel get owner => xFormModel.formModel;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
