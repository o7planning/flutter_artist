import '../_core_/core.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_selection_type.dart';
import 'string_value_filter_criteria.dart';
import 'string_value_filter_input.dart';

class StringValueFilterModel
    extends FilterModel<StringValueFilterInput, StringValueFilterCriteria> {
  final String? _stringValue;

  StringValueFilterModel({required String? stringValue})
      : _stringValue = stringValue;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<String>(criterionBaseName: 'string'),
      ],
      multiOptCriterionDefs: [],
      //
      conditionConnector: ConditionConnector.and,
      conditionDefs: [
        ConditionDef.single(
          criterionNameTilde: "string${CriterionTilde.symbol}",
          operator: CriterionOperator.equalTo,
        ),
      ],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required StringValueFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptCriterion({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required StringValueFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
    required XData multiOptCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleCriteria({
    required StringValueFilterInput filterInput,
  }) {
    return {
      "string${CriterionTilde.symbol}":
          SimpleValueWrap(filterInput.stringValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria() {
    return {
      "string${CriterionTilde.symbol}": _stringValue,
    };
  }

  @override
  StringValueFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
  }) {
    return StringValueFilterCriteria(
      stringValue: criteriaMap["string${CriterionTilde.symbol}"],
    );
  }
}
