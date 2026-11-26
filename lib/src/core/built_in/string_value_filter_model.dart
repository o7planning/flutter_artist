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
        plainCriterionDefs: [
          PlainFilterCriterionDef<String>(criterionBaseName: 'string'),
        ],
        managedOptCriterionDefs: [],
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
  Future<XData?> performLoadManagedOptTildeCriterionXData({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractPatchValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required StringValueFilterPatch filterPatch,
    required XData managedOptTildeCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainTildeCriteria({
    required StringValueFilterPatch filterPatch,
  }) {
    return {
      "string$tildeSymbol": PlainValueWrap.of(filterPatch.stringValue),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForPlainTildeCriteria() {
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
