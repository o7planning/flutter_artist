import '../_core_/core.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_selection_type.dart';
import 'search_text_filter_criteria.dart';
import 'search_text_filter_input.dart';

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterInput, SearchTextFilterCriteria> {
  final String? _searchText;

  SearchTextFilterModel({required String? searchText})
      : _searchText = searchText;

  @override
  FilterModelStructure registerCriteriaStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<String>(criterionBaseName: 'searchText'),
      ],
      multiOptCriterionDefs: [],
      //
      simpleCriteria: [
        SimpleFilterCriterionModel<String>(criterionNameX: "searchText"),
      ],
      multiOptCriteria: [],
      connector: ConditionConnector.and,
      conditionDefs: [],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required SearchTextFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required SearchTextFilterInput filterInput,
  }) {
    return {
      "searchText": SimpleValueWrap(filterInput.searchText),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria() {
    return {
      "searchText": _searchText,
    };
  }

  @override
  SearchTextFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
  }) {
    return SearchTextFilterCriteria(searchText: criteriaMap["searchText"]);
  }
}
