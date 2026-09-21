part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FilterPanelChangeAnnotation()
class _FilterPanelChangeExecutionUnit extends _ShelfMemberExecutionUnit {
  XFilterModel xFilterModel;

  @override
  final FilterModelFilterPanelChangeIntent executionIntent;

  _FilterPanelChangeExecutionUnit({
    required this.xFilterModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.filterModelFilterPanelChanged,
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
