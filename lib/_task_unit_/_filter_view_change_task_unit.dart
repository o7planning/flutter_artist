part of '../flutter_artist.dart';

class _FilterViewChangeTaskUnit extends _TaskUnit {
  _XFilterModel xFilterModel;

  _FilterViewChangeTaskUnit({
    required this.xFilterModel,
  });

  @override
  int get xShelfId => xFilterModel.xShelfId;

  @override
  Shelf get shelf => xFilterModel.filterModel.shelf;

  @override
  String getObjectName() {
    return xFilterModel.filterModel.name;
  }
}
