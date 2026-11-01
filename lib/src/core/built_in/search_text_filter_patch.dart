part of '__built_in_model.dart';

class SearchTextFilterPatch extends FilterPatch {
  final String? searchText;

  const SearchTextFilterPatch({required this.searchText});

  @override
  List<Object?> get props => [searchText];

  @override
  String toString() {
    return "SearchTextFilterPatch('$searchText')";
  }
}
