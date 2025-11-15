import '../_core_/core.dart';

class SearchTextFilterInput extends FilterInput {
  final String? searchText;

  SearchTextFilterInput({required this.searchText});

  @override
  String toString() {
    return "SearchTextFilterInput('$searchText')";
  }
}
