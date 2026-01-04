import '../_core_/core.dart';

///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  SearchTextFilterCriteria({required this.searchText})
      // TODO: Xem lai.
      : super(
            conditionStructure: ConditionStructureDetail.empty(), criteria: []);

  @override
  List<String> getDebugCriterionInfos() {
    return ["searchText: $searchText"];
  }
}
