part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_FormModelLoadFormAnnotation()
class _FormModelLoadFormTaskUnit extends _TaskUnit<FormModelLoadDataResult> {
  _XFormModel xFormModel;

  _FormModelLoadFormTaskUnit({
    required this.xFormModel,
  }) : super(
          taskType: TaskType.formModelLoadForm,
          taskResult: FormModelLoadDataResult(),
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
