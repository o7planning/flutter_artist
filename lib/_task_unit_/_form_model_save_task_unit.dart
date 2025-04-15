part of '../flutter_artist.dart';

class _SaveFormSaveTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _SaveFormSaveTaskUnit({
    required this.xFormModel,
  });

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.block.shelf;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
