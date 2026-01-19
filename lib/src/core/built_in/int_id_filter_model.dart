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
  FilterModelStructure registerCriteriaStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<int>(criterionBaseName: 'id'),
      ],
      multiOptCriterionDefs: [],
      //
      connector: ConditionConnector.and,
      conditionDefs: [
        ConditionDef.single(
          criterionNameX: "id${CriterionX.symbol}",
          operator: CriterionOperator.equalTo,
        ),
      ],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required Object? parentMultiOptCriterionValue,
    required IntIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required IntIdFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required IntIdFilterInput filterInput,
  }) {
    return {
      "id": SimpleValueWrap(filterInput.idValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
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
    required Map<String, dynamic> criteriaMap,
  }) {
    return IntIdFilterCriteria(idValue: criteriaMap["id"]);
  }
}
