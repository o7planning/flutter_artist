part of '_built_in_filter_criteria.dart';

class SearchTextFilterInput extends FilterInput {
  final String? searchText;

  const SearchTextFilterInput({required this.searchText});

  @override
  List<Object?> get props => [searchText];

  @override
  String toString() {
    return "SearchTextFilterInput('$searchText')";
  }
}
