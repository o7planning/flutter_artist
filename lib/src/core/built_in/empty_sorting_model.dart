import '../_core_/core.dart';

class EmptySortingModel<ITEM extends Object> extends SortingModel<ITEM> {
  EmptySortingModel() : super(sortableCriterionNames: []);

  @override
  String? getText({required String criterionName}) {
    return criterionName;
  }

  @override
  dynamic getValue({required ITEM item, required String criterionName}) {
    return null;
  }
}
