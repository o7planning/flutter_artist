part of '../core.dart';

class _XFilterModel {
  final _XShelf xShelf;
  final FilterModel filterModel;

  final List<_XBlock> xBlocks = [];
  final List<_XScalar> xScalars = [];

  bool queried = false;
  FilterInput? filterInput;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  _XFilterModel({required this.xShelf, required this.filterModel});

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
