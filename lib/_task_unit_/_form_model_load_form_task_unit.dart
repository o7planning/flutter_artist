part of '../flutter_artist.dart';

class _FormModelLoadFormTaskUnit extends _TaskUnit {
  _XFormModel xFormModel;

  _FormModelLoadFormTaskUnit({
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
