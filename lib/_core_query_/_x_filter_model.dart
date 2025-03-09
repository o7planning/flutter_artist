part of '../flutter_artist.dart';

class _XFilterModel {
  bool queried = false;
  final FilterModel dataFilter;
  FilterInput? filterInput;

  _XFilterModel({
    required this.dataFilter,
  });

  String get name => dataFilter.name;

  @override
  String toString() {
    return "${getClassName(dataFilter)} - queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
