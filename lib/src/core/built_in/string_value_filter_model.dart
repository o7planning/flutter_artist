import 'package:flutter_artist/src/core/enums/_filter_criterion_operator.dart';

import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'string_value_filter_criteria.dart';
import 'string_value_filter_input.dart';

class StringValueFilterModel
    extends FilterModel<StringValueFilterInput, StringValueFilterCriteria> {
  final String? _stringValue;
  final CriterionOperator criterionOperator;

  StringValueFilterModel({
    required String? stringValue,
    this.criterionOperator = CriterionOperator.contains,
  }) : _stringValue = stringValue;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleFilterCriterionDef<String>(
          criterionBaseName: "string",
        ),
      ],
      multiOptCriterionDefs: [],
      filterCriteriaGroupDef: FilterCriteriaGroupDef(
        groupName: 'rootCriteriaGroup',
        conjunction: Conjunction.and,
        members: [
          FilterConditionDef(
            criterionNamePlus: "string+",
            operator: CriterionOperator.containsIgnoreCase,
          ),
        ],
      ),
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required StringValueFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String criteriaGroupName,
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
    required String criteriaGroupName,
    required StringValueFilterInput filterInput,
  }) {
    return {
      "string": SimpleValueWrap(filterInput.stringValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria({
    required String criteriaGroupName,
  }) {
    return {
      "string": _stringValue,
    };
  }

  @override
  StringValueFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
    required FilterCriteriaGroupModel filterCriteriaGroup,
    required List<FilterCriterion> filterCriteria,
  }) {
    return StringValueFilterCriteria(
      stringValue: criteriaMap["string"],
    );
  }
}
