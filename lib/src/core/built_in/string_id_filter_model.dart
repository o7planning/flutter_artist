import '../_core_/core.dart';
import '../enums/_filter_connector.dart';
import '../enums/_filter_operator.dart';
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
      criteriaStructure: FilterCriteriaStructure(
        simpleCriterionDefs: [
          SimpleFilterCriterionDef<String>(criterionBaseName: 'id'),
        ],
        multiOptCriterionDefs: [],
      ),
      conditionStructure: FilterConditionStructure(
        connector: FilterConnector.and,
        conditionDefs: [
          FilterConditionDef.simple(
            tildeCriterionName: "id$tildeSymbol",
            operator: FilterOperator.equalTo,
          ),
        ],
      ),
    );
  }

  @override
  Future<XData?> performLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required StringIdFilterInput? filterInput,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
    required StringIdFilterInput filterInput,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required StringIdFilterInput filterInput,
  }) {
    return {
      "id$tildeSymbol": SimpleValueWrap(filterInput.idValue),
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
      "id$tildeSymbol": _idValue,
    };
  }

  @override
  StringIdFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return StringIdFilterCriteria(
      idValue: tildeCriteriaMap["id$tildeSymbol"],
    );
  }
}
