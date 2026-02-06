import '../_core_/core.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_selection_type.dart';
import 'int_id_filter_criteria.dart';
import 'int_id_filter_input.dart';

// Example: [14809].
class IntIdFilterModel
    extends FilterModel<IntIdFilterInput, IntIdFilterCriteria> {
  final int? _idValue;

  IntIdFilterModel({int? idValue}) : _idValue = idValue;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<int>(criterionBaseName: 'id'),
      ],
      multiOptCriterionDefs: [],
      //
      conditionConnector: ConditionConnector.and,
      conditionDefs: [
        ConditionDef.condition(
          tildeCriterionName: "id$tildeSymbol",
          operator: CriterionOperator.equalTo,
        ),
      ],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required IntIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required IntIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required IntIdFilterInput filterInput,
  }) {
    return {
      "id$tildeSymbol": SimpleValueWrap(filterInput.idValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleTildeCriteria() {
    return {
      "id$tildeSymbol": _idValue,
    };
  }

  @override
  IntIdFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> criteriaMap,
  }) {
    return IntIdFilterCriteria(
      idValue: criteriaMap["id$tildeSymbol"],
    );
  }
}
