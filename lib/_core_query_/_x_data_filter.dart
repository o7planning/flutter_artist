part of '../flutter_artist.dart';

class _XDataFilter {
  bool queried = false;
  final DataFilter dataFilter;
  SuggestedCriteria? suggestedFilterData;

  _XDataFilter({
    required this.dataFilter,
  });

  String get name => dataFilter.name;

  @override
  String toString() {
    return "${getClassName(dataFilter)} - queried: $queried >>> SUGGESTED_CRITERIA: $suggestedFilterData";
  }
}
