import '../_core_/core.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_selection_type.dart';
import 'string_id_filter_criteria.dart';
import 'string_id_filter_input.dart';

class StringIdFilterModel
    extends FilterModel<StringIdFilterInput, StringIdFilterCriteria> {
  final String? _idValue;

  StringIdFilterModel({required String? idValue}) : _idValue = idValue;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<String>(criterionBaseName: 'id'),
      ],
      multiOptCriterionDefs: [],
      //
      conditionConnector: ConditionConnector.and,
      conditionDefs: [
        ConditionDef.single(
          criterionNameTilde: "id${CriterionTilde.symbol}",
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
    required Object? parentMultiOptCriterionValue,
    required StringIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptCriterion({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required StringIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleCriteria({
    required StringIdFilterInput filterInput,
  }) {
    return {
      "id${CriterionTilde.symbol}": SimpleValueWrap(filterInput.idValue),
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
      "id${CriterionTilde.symbol}": _idValue,
    };
  }

  @override
  StringIdFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> criteriaMap,
  }) {
    return StringIdFilterCriteria(
      idValue: criteriaMap["id${CriterionTilde.symbol}"],
    );
  }
}
