part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterModelLoadDataAnnotation()
class _FilterModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FilterModelDataLoadResult> {
  XFilterModel xFilterModel;

  @override
  FilterModelTodoLoad executionTodo;

  _FilterModelLoadDataExecutionUnit({
    required this.xFilterModel,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.filterModelLoadData,
          executionUnitResult: FilterModelDataLoadResult(),
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
