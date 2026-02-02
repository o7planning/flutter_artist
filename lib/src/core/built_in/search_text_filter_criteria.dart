import '../_core_/core.dart';

///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  SearchTextFilterCriteria({
    required this.searchText,
  });

  @override
  List<FilterCriterion<Object>> registerSupportedCriteria() {
    return [
      FilterCriterion<String>(
        filterCriterionName: 'searchText',
        filterFieldName: 'searchText',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }
}
