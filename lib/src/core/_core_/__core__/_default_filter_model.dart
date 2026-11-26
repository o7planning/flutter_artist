part of '../core.dart';

class _DefaultFilterModel
    extends FilterModel<EmptyFilterPatch, EmptyFilterCriteria> {
  _DefaultFilterModel({
    required String name,
    required Shelf shelf,
  }) {
    this.name = name;
    this.shelf = shelf;
    _isDefaultFilterModel = true;
  }

  @override
  FilterModelStructure defineFilterModelStructure() {
    return FilterModelStructure(
      criteriaStructure: FilterCriteriaStructure(
        plainCriterionDefs: [],
        managedOptCriterionDefs: [],
      ),
      conditionStructure: FilterConditionStructure(
        connector: FilterConnector.and,
        conditionDefs: [],
      ),
    );
  }

  @override
  Future<ListXData?> performLoadManagedOptTildeCriterionXData({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required Object? parentManagedOptTildeCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractPatchValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
    required EmptyFilterPatch filterPatch,
    required Object? parentManagedOptTildeCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainTildeCriteria({
    required EmptyFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  OptValueWrap? specifyDefaultValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
    required Object? parentManagedOptTildeCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForPlainTildeCriteria() {
    return null;
  }

  @override
  EmptyFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return EmptyFilterCriteria();
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
