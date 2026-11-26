part of '__built_in_model.dart';

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterPatch, SearchTextFilterCriteria> {
  final String? _searchText;

  SearchTextFilterModel({required String? searchText})
      : _searchText = searchText;

  @override
  FilterModelStructure defineFilterModelStructure() {
    return FilterModelStructure(
      criteriaStructure: FilterCriteriaStructure(
        plainCriterionDefs: [
          PlainFilterCriterionDef<String>(criterionBaseName: 'searchText'),
        ],
        managedOptCriterionDefs: [],
      ),
      conditionStructure: FilterConditionStructure(
        connector: FilterConnector.and,
        conditionDefs: [
          FilterConditionDef.simple(
            tildeCriterionName: "searchText$tildeSymbol",
            operator: FilterOperator.containsIgnoreCase,
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
    required SearchTextFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainTildeCriteria({
    required SearchTextFilterPatch filterPatch,
  }) {
    return {
      "searchText$tildeSymbol": PlainValueWrap.of(filterPatch.searchText),
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
      "searchText$tildeSymbol": _searchText,
    };
  }

  @override
  SearchTextFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  }) {
    return SearchTextFilterCriteria(
      searchText: tildeCriteriaMap["searchText$tildeSymbol"],
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
