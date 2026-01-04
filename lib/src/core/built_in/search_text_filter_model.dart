import '../_core_/core.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_selection_type.dart';
import 'search_text_filter_criteria.dart';
import 'search_text_filter_input.dart';

class SearchTextFilterModel
    extends FilterModel<SearchTextFilterInput, SearchTextFilterCriteria> {
  final CriterionOperator criterionOperator;
  final String? _searchText;

  SearchTextFilterModel({
    required String? searchText,
    this.criterionOperator = CriterionOperator.containsIgnoreCase,
  }) : _searchText = searchText;

  @override
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleFilterCriterionDef<String>(
          criterionBaseName: "searchText",
        ),
      ],
      multiOptCriterionDefs: [],
      filterCriteriaGroupDef: FilterCriteriaGroupDef(
        groupName: 'rootCriteriaGroup',
        conjunction: Conjunction.and,
        members: [
          FilterConditionDef(
            criterionNamePlus: "searchText+",
            operator: CriterionOperator.containsIgnoreCase,
          ),
        ],
      ),
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required SearchTextFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required String criteriaGroupName,
    required SearchTextFilterInput filterInput,
  }) {
    return {
      "searchText": SimpleValueWrap(filterInput.searchText),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String criteriaGroupName,
    required String multiOptCriterionName,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria({
    required String criteriaGroupName,
  }) {
    return {
      "searchText": _searchText,
    };
  }

  @override
  SearchTextFilterCriteria toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
    required FilterCriteriaGroupModel filterCriteriaGroup,
    required List<FilterCriterion> filterCriteria,
  }) {
    return SearchTextFilterCriteria(searchText: criteriaMap["searchText"]);
  }
}
