import 'package:flutter_artist/src/core/enums/_filter_criterion_operator.dart';

import '../_core_/core.dart';
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
        SimpleFilterCriterionDef<String>(
          criterionBaseName: "id",
        ),
      ],
      multiOptCriterionDefs: [],
      filterCriteriaGroupDef: FilterCriteriaGroupDef(
        groupName: 'rootCriteriaGroup',
        conjunction: Conjunction.and,
        members: [
          FilterConditionDef(
            criterionNamePlus: "id+",
            operator: CriterionOperator.equalTo,
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
    required Object? parentMultiOptCriterionValue,
    required StringIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String criteriaGroupName,
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
    required String criteriaGroupName,
    required StringIdFilterInput filterInput,
  }) {
    return {
      "id": SimpleValueWrap(filterInput.idValue),
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
      "id": _idValue,
    };
  }

  @override
  StringIdFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
    required FilterCriteriaGroupModel filterCriteriaGroup,
    required List<FilterCriterion> filterCriteria,
  }) {
    return StringIdFilterCriteria(idValue: criteriaMap["id"]);
  }
}
