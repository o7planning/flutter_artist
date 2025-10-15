part of '../core.dart';

class _ClientSideSortingModel<ITEM extends Object> extends SortingModel<ITEM> {
  final SortingModel<ITEM> __innerSortingModel;

  _ClientSideSortingModel(SortingModel<ITEM> innerSortingModel)
      : __innerSortingModel = innerSortingModel,
        super(
          multiOptions: innerSortingModel.multiOptions,
          sortableCriterionNames:
              innerSortingModel._sortableCriterionNamesOrigin,
        );

  @override
  String? getText({required String criterionName}) {
    return __innerSortingModel.getText(criterionName: criterionName);
  }

  @override
  dynamic getValue({required ITEM item, required String criterionName}) {
    return __innerSortingModel.getValue(
        item: item, criterionName: criterionName);
  }
}
