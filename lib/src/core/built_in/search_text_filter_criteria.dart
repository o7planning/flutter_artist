part of '__built_in_model.dart';

///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  SearchTextFilterCriteria({
    required this.searchText,
  });
}
