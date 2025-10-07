import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'int_id_filter_criteria.dart';
import 'int_id_filter_input.dart';

class IntIdFilterModel
    extends FilterModel<IntIdFilterInput, IntIdFilterCriteria> {
  final int? _idValue;

  IntIdFilterModel({required int? idValue}) : _idValue = idValue;

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [
        SimpleCriterion<int>(criterionName: "id"),
      ],
      multiOptCriteria: [],
    );
  }

  @override
  IntIdFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: dataMap["id"]);
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required IntIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required IntIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? getSimpleCriterionValuesFromFilterInput({
    required IntIdFilterInput filterInput,
  }) {
    return {
      "id": filterInput.idValue,
    };
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultSimpleCriterionValues() {
    return {
      "id": _idValue,
    };
  }
}
