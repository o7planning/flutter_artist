import '../_core_/core.dart';

class EmptySortModel<ITEM extends Object> extends SortModel<ITEM> {
  EmptySortModel() : super(sortableCriterionNames: {});

  @override
  String? getText({required String criterionName}) {
    return criterionName;
  }

  @override
  dynamic getValue({required ITEM item, required String criterionName}) {
    return null;
  }
}
