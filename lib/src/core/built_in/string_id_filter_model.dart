import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'string_id_filter_criteria.dart';
import 'string_id_filter_input.dart';

class StringIdFilterModel
    extends FilterModel<StringIdFilterInput, StringIdFilterCriteria> {
  final String? _idValue;

  StringIdFilterModel({required String? idValue}) : _idValue = idValue;

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [
        SimpleFilterCriterion<String>(criterionName: "id"),
      ],
      multiOptCriteria: [],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required StringIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required StringIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required StringIdFilterInput filterInput,
  }) {
    return {
      "id": SimpleValueWrap(filterInput.idValue),
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
  StringIdFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return StringIdFilterCriteria(idValue: dataMap["id"]);
  }
}
