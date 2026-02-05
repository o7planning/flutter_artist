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
  FilterModelStructure registerFilterModelStructure() {
    return FilterModelStructure(
      simpleCriterionDefs: [
        SimpleCriterionDef<String>(criterionBaseName: 'searchText'),
      ],
      multiOptCriterionDefs: [],
      //
      conditionConnector: ConditionConnector.and,
      conditionDefs: [
        ConditionDef.condition(
          criterionNameTilde: "searchText$tildeSymbol",
          operator: CriterionOperator.containsIgnoreCase,
        ),
      ],
    );
  }

  @override
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required SearchTextFilterInput? filterInput,
    required Object? parentMultiOptCriterionValue,
  }) async {
    return null;
  }

  @override
  OptValueWrap? extractUpdateValueForMultiOptCriterion({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required SearchTextFilterInput filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleCriteria({
    required SearchTextFilterInput filterInput,
  }) {
    return {
      "searchText$tildeSymbol": SimpleValueWrap(filterInput.searchText),
    };
  }

  @override
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionBaseName,
    required String multiOptCriterionNameTilde,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    return null;
  }

  @override
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria() {
    return {
      "searchText$tildeSymbol": _searchText,
    };
  }

  @override
  SearchTextFilterCriteria createNewFilterCriteria({
    required Map<String, dynamic> criteriaMap,
  }) {
    return SearchTextFilterCriteria(
      searchText: criteriaMap["searchText$tildeSymbol"],
    );
  }
}
