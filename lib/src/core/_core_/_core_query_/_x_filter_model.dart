part of '../core.dart';

class XFilterModel {
  final XShelf xShelf;
  final FilterModel filterModel;

  final List<XBlock> xBlocks = [];
  final List<XScalar> xScalars = [];

  bool queried = false;
  FilterInput? filterInput;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  XFilterModel({required this.xShelf, required this.filterModel});

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
