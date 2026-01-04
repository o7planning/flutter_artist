import 'package:flutter_artist/src/core/enums/_filter_criterion_operator.dart';

import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'string_value_filter_criteria.dart';
import 'string_value_filter_input.dart';

class StringValueFilterModel
    extends FilterModel<StringValueFilterInput, StringValueFilterCriteria> {
  final String? _stringValue;
  final FilterCriterionOperator criterionOperator;

  StringValueFilterModel({
    required String? stringValue,
    this.criterionOperator = FilterCriterionOperator.contains,
  }) : _stringValue = stringValue;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionModels: [
        SimpleFilterCriterionModel<String>(
          criterionName: "string",
          operator: criterionOperator,
        ),
      ],
      multiOptCriterionModels: [],
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
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required StringValueFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
    required XData multiOptCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required StringValueFilterInput filterInput,
  }) {
    return {
      "string": SimpleValueWrap(filterInput.stringValue),
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
      "string": _stringValue,
    };
  }

  @override
  StringValueFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
  }) {
    return StringValueFilterCriteria(
      stringValue: criteriaMap["string"],
    );
  }
}
