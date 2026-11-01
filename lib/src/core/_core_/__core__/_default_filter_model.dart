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
        simpleCriterionDefs: [],
        multiOptCriterionDefs: [],
      ),
      conditionStructure: FilterConditionStructure(
        connector: FilterConnector.and,
        conditionDefs: [],
      ),
    );
  }

  @override
  Future<ListXData?> performLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required MultiOptSelectionMode multiOptSelectionMode,
    required Object? parentMultiOptTildeCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractPatchValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required MultiOptSelectionMode multiOptSelectionMode,
    required XData multiOptTildeCriterionXData,
    required EmptyFilterPatch filterPatch,
    required Object? parentMultiOptTildeCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractPatchValuesForSimpleTildeCriteria({
    required EmptyFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required MultiOptSelectionMode multiOptSelectionMode,
    required XData multiOptTildeCriterionXData,
    required Object? parentMultiOptTildeCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleTildeCriteria() {
    return null;
  }

  @override
  EmptyFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return EmptyFilterCriteria();
  }
}
