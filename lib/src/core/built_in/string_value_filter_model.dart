import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'string_value_filter_criteria.dart';
import 'string_value_filter_input.dart';

class StringValueFilterModel
    extends FilterModel<StringValueFilterInput, StringValueFilterCriteria> {
  final String? _stringValue;

  StringValueFilterModel({required String? stringValue})
      : _stringValue = stringValue;

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [
        SimpleCriterion<String>(criterionName: "string"),
      ],
      multiOptCriteria: [],
    );
  }

  @override
  StringValueFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return StringValueFilterCriteria(
      stringValue: dataMap["string"],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required StringValueFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required StringValueFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
    required XData multiOptCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? getSimpleCriterionValuesFromFilterInput({
    required StringValueFilterInput filterInput,
  }) {
    return {
      "string": filterInput.stringValue,
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
      "string": _stringValue,
    };
  }
}
