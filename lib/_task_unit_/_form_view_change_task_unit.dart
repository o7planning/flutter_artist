part of '../flutter_artist.dart';

class _FormViewChangeTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _FormViewChangeTaskUnit({
    required this.xFormModel,
  });

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.shelf;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
