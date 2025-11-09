import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'int_id_filter_criteria.dart';
import 'int_id_filter_input.dart';

// Example: [14809].
class IntIdFilterModel
    extends FilterModel<IntIdFilterInput, IntIdFilterCriteria> {
  final int? _idValue;

  IntIdFilterModel({int? idValue}) : _idValue = idValue;

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [
        SimpleFilterCriterion<int>(criterionName: "id"),
      ],
      multiOptCriteria: [],
    );
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
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required IntIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? getUpdatedValuesForSimpleCriteria({
    required IntIdFilterInput filterInput,
  }) {
    return {
      "id": filterInput.idValue,
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria() {
    return {
      "id": _idValue,
    };
  }

  @override
  IntIdFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return IntIdFilterCriteria(idValue: dataMap["id"]);
  }
}
