import 'package:flutter_artist/src/core/enums/_filter_criterion_operator.dart';

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
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionModels: [
        SimpleFilterCriterionModel<int>(
          criterionName: "id",
          operator: FilterCriterionOperator.equalTo,
        ),
      ],
      multiOptCriterionModels: [],
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
