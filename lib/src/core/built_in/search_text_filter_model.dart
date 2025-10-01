import '../_core_/core.dart';
import '../enums/_selection_type.dart';
import 'search_text_filter_criteria.dart';
import 'search_text_filter_input.dart';

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterInput, SearchTextFilterCriteria> {
  final String? _searchText;

  SearchTextFilterModel({required String? searchText})
      : _searchText = searchText;

  @override
  FilterCriteriaStructure registerCriteriaStructure() {
    return FilterCriteriaStructure(
      simpleCriteria: [
        SimpleCriterion<String>(criterionName: "searchText"),
      ],
      multiOptCriteria: [],
    );
  }

  @override
  SearchTextFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  }) {
    return SearchTextFilterCriteria(searchText: dataMap["searchText"]);
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  ValueWrap? getMultiOptCriterionValueFromFilterInput({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required SearchTextFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getSimpleCriterionValuesFromFilterInput({
    required SearchTextFilterInput filterInput,
  }) async {
    return {
      "searchText": filterInput.searchText,
    };
  }

  @override
  ValueWrap? specifyDefaultMultiOptCriterionValue({
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> specifyDefaultSimpleCriterionValues() async {
    return {
      "searchText": _searchText,
    };
  }
}
