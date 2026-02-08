import '../_core_/core.dart';
import '../enums/_filter_operator.dart';
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
        ConditionDef.condition(
          tildeCriterionName: "string$tildeSymbol",
          operator: FilterOperator.equalTo,
        ),
      ],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required StringValueFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required StringValueFilterInput filterInput,
    required XData multiOptTildeCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required StringValueFilterInput filterInput,
  }) {
    return {
      "string$tildeSymbol": SimpleValueWrap(filterInput.stringValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleTildeCriteria() {
    return {
      "string$tildeSymbol": _stringValue,
    };
  }

  @override
  StringValueFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return StringValueFilterCriteria(
      stringValue: tildeCriteriaMap["string$tildeSymbol"],
    );
  }
}
