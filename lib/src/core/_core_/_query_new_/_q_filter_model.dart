part of '../core.dart';

class _QFilterModel {
  final _QShelf xShelf;
  final FilterModel filterModel;

  bool queried = false;
  FilterInput? filterInput;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  _QFilterModel({required this.xShelf, required this.filterModel});

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
