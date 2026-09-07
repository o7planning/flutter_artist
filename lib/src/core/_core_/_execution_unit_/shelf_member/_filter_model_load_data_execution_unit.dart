part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterModelLoadDataAnnotation()
class _FilterModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FilterModelDataLoadResult> {
  final XFilterModel xFilterModel;

  @override
  final FilterModelLoadIntent executionIntent;

  _FilterModelLoadDataExecutionUnit({
    required this.xFilterModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.filterModelLoadData,
          executionIntent: executionIntent,
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
