import '../_core_/core.dart';
import '../utils/_string_utils.dart';

///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  const SearchTextFilterCriteria({required this.searchText});

  @override
  List<String> getDebugCriterionInfos() {
    return ["searchText: $searchText"];
  }

  @override
  List<Object?> get props => [StrUtils.stringToNullIfEmpty(searchText)];
}
