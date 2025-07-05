part of '../../flutter_artist.dart';

@_FormModelSaveFormAnnotation()
class _FormModelSaveFormTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _FormModelSaveFormTaskUnit({
    required this.xFormModel,
  }) : super(taskType: TaskType.formModelSaveForm);

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
