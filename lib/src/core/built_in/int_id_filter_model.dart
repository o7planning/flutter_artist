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
        plainCriterionDefs: [
          PlainFilterCriterionDef<int>(criterionBaseName: 'id'),
        ],
        managedOptCriterionDefs: [],
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
    required XData managedOptTildeCriterionXData,
    required IntIdFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainTildeCriteria({
    required IntIdFilterPatch filterPatch,
  }) {
    return {
      "id$tildeSymbol": PlainValueWrap.of(filterPatch.idValue),
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
