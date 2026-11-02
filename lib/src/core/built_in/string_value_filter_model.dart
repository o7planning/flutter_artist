part of '__built_in_model.dart';

class StringValueFilterModel
    extends FilterModel<StringValueFilterPatch, StringValueFilterCriteria> {
  final String? _stringValue;

  StringValueFilterModel({required String? stringValue})
      : _stringValue = stringValue;

  @override
  FilterModelStructure defineFilterModelStructure() {
    return FilterModelStructure(
      criteriaStructure: FilterCriteriaStructure(
        simpleCriterionDefs: [
          SimpleFilterCriterionDef<String>(criterionBaseName: 'string'),
        ],
        multiOptCriterionDefs: [],
      ),
      conditionStructure: FilterConditionStructure(
        connector: FilterConnector.and,
        conditionDefs: [
          FilterConditionDef.simple(
            tildeCriterionName: "string$tildeSymbol",
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
    required StringValueFilterPatch filterPatch,
    required XData multiOptTildeCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractPatchValuesForSimpleTildeCriteria({
    required StringValueFilterPatch filterPatch,
  }) {
    return {
      "string$tildeSymbol": SimpleValueWrap.of(filterPatch.stringValue),
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

  @override
  FocusNavAction? resolveNextFocus({
    required String currentTildeCriterionName,
    required currentValue,
    required bool isCurrentFieldValid,
  }) {
    return null;
  }
}
