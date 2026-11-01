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
        simpleCriterionDefs: [
          SimpleFilterCriterionDef<String>(criterionBaseName: 'searchText'),
        ],
        multiOptCriterionDefs: [],
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
    required SearchTextFilterPatch filterPatch,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractPatchValuesForSimpleTildeCriteria({
    required SearchTextFilterPatch filterPatch,
  }) {
    return {
      "searchText$tildeSymbol": SimpleValueWrap.of(filterPatch.searchText),
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
}
