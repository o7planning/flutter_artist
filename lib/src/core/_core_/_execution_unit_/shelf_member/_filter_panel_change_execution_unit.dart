part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterPanelChangeAnnotation()
class _FilterPanelChangeExecutionUnit extends _ShelfMemberExecutionUnit {
  XFilterModel xFilterModel;
  final FilterModelTodoPanelChange executionTodo;

  _FilterPanelChangeExecutionUnit({
    required this.xFilterModel,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.filterModelFilterPanelChanged,
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
