part of '__built_in_model.dart';

// Example: [14809].
class IntIdFilterModel
    extends FilterModel<IntIdFilterPatch, IntIdFilterCriteria> {
  final int? _idValue;

  IntIdFilterModel({int? idValue}) : _idValue = idValue;

  @override
  FilterModelStructure defineFilterModelStructure() {
    return FilterModelStructure(
      criteriaStructure: FilterCriteriaStructure(
        simpleCriterionDefs: [
          SimpleFilterCriterionDef<int>(criterionBaseName: 'id'),
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
    required IntIdFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractPatchValuesForSimpleTildeCriteria({
    required IntIdFilterPatch filterPatch,
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
  IntIdFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return IntIdFilterCriteria(
      idValue: tildeCriteriaMap["id$tildeSymbol"],
    );
  }

  @override
  FocusNavAction? resolveNextFocus({
    required String currentTildeCriterionName,
    required currentValue,
    required bool isCurrentFieldValid,
  }) {
    return null;
  }
}
