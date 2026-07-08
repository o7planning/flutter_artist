part of '../core.dart';

@_TaskUnitClassAnnotation()
@_FilterPanelChangeAnnotation()
class _FilterPanelChangeTaskUnit extends _STaskUnit {
  XFilterModel xFilterModel;
  final Map<String, dynamic> formKeyInstantValuesInUI;

  _FilterPanelChangeTaskUnit({
    required this.xFilterModel,
    required this.formKeyInstantValuesInUI,
  }) : super(taskType: TaskType.filterModelFilterPanelChanged);

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
