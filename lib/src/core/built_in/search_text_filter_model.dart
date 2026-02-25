import '../_core_/core.dart';
import '../enums/_filter_connector.dart';
import '../enums/_filter_operator.dart';
import '../enums/_selection_type.dart';
import 'search_text_filter_criteria.dart';
import 'search_text_filter_input.dart';

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterInput, SearchTextFilterCriteria> {
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
    required SelectionType selectionType,
    required SearchTextFilterInput? filterInput,
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
    required SearchTextFilterInput filterInput,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required SearchTextFilterInput filterInput,
  }) {
    return {
      "searchText$tildeSymbol": SimpleValueWrap(filterInput.searchText),
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
