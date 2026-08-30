part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterModelLoadDataAnnotation()
class _FilterModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FilterModelDataLoadResult> {
  XFilterModel xFilterModel;

  _FilterModelLoadDataExecutionUnit({
    required this.xFilterModel,
  }) : super(
          executionUnitType: ExecutionUnitType.filterModelLoadData,
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
