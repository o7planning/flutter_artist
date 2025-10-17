part of '../core.dart';

class _ClientSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  final SortModel<ITEM> __innerSortModel;

  _ClientSideSortModel(SortModel<ITEM> innerSortModel)
      : __innerSortModel = innerSortModel,
        super._client(
          multiOptionMode: innerSortModel.multiOptionMode,
          sortableCriterionNames: innerSortModel._originCriterionNameMap,
        );

  @override
  String? getText({required String criterionName}) {
    return __innerSortModel.getText(criterionName: criterionName);
  }

  @override
  dynamic getValue({required ITEM item, required String criterionName}) {
    return __innerSortModel.getValue(item: item, criterionName: criterionName);
  }
}
