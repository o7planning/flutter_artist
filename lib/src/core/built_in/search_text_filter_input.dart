part of '__built_in_model.dart';

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
