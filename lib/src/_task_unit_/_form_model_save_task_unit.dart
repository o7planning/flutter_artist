part of '../../flutter_artist.dart';

class _SaveFormSaveTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _SaveFormSaveTaskUnit({
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
