part of '../../flutter_artist.dart';

class _FormModelLoadFormTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _FormModelLoadFormTaskUnit({
    required this.xFormModel,
  }) : super(taskType: TaskType.formModelLoadForm);

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
