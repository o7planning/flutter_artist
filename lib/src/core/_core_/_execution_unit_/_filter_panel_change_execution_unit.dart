part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterPanelChangeAnnotation()
class _FilterPanelChangeExecutionUnit extends _SExecutionUnit {
  XFilterModel xFilterModel;
  final Map<String, dynamic> formKeyInstantValuesInUI;

  _FilterPanelChangeExecutionUnit({
    required this.xFilterModel,
    required this.formKeyInstantValuesInUI,
  }) : super(executionUnitType: ExecutionUnitType.filterModelFilterPanelChanged);

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
