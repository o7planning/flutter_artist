part of '__built_in_model.dart';

class StringIdFilterModel
    extends FilterModel<StringIdFilterPatch, StringIdFilterCriteria> {
  final String? _idValue;

  StringIdFilterModel({required String? idValue}) : _idValue = idValue;

  @override
  FilterModelStructure defineFilterModelStructure() {
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
    required MultiOptSelectionMode multiOptSelectionMode,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractPatchValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required MultiOptSelectionMode multiOptSelectionMode,
    required XData multiOptTildeCriterionXData,
    required StringIdFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractPatchValuesForSimpleTildeCriteria({
    required StringIdFilterPatch filterPatch,
  }) {
    return {
      "id$tildeSymbol": SimpleValueWrap.of(filterPatch.idValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required MultiOptSelectionMode multiOptSelectionMode,
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
