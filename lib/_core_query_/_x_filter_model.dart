part of '../flutter_artist.dart';

class _XFilterModel {
  bool queried = false;
  final FilterModel filterModel;
  FilterInput? filterInput;

  _XFilterModel({
    required this.filterModel,
  });

  String get name => filterModel.name;

  @override
  String toString() {
    return "${getClassName(filterModel)} - queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
