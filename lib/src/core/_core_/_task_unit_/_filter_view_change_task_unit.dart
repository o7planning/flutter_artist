part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FilterViewChangeAnnotation()
class _FilterViewChangeTaskUnit extends _TaskUnit {
  _XFilterModel xFilterModel;

  _FilterViewChangeTaskUnit({
    required this.xFilterModel,
  }) : super(taskType: TaskType.filterModelFilterViewChanged);

  @override
  _XShelf get xShelf => xFilterModel.xShelf;

  @override
  int get xShelfId => xFilterModel.xShelfId;

  @override
  Shelf get shelf => xFilterModel.filterModel.shelf;

  @override
  FilterModel get owner => xFilterModel.filterModel;

  @override
  String getObjectName() {
    return xFilterModel.filterModel.name;
  }
}
