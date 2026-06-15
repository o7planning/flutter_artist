part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FilterModelLoadDataAnnotation()
class _FilterModelLoadDataTaskUnit
    extends _ResultedSTaskUnit<FilterModelDataLoadResult> {
  XFilterModel xFilterModel;

  _FilterModelLoadDataTaskUnit({
    required this.xFilterModel,
  }) : super(
    taskType: TaskType.filterModelLoadData,
    taskResult: FilterModelDataLoadResult(),
  );

  @override
  XShelf get xShelf => xFilterModel.xShelf;

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
