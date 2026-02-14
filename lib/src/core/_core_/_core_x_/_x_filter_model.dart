part of '../core.dart';

int __xFilterModelSeq = 0;

class XFilterModel {
  final int _xFilterModelId;
  final XShelf xShelf;
  final FilterModel filterModel;

  final List<XBlock> xBlocks = [];
  final List<XScalar> xScalars = [];

  bool queried = false;
  FilterInput? filterInput;

  bool get isDefaultFilterModel => filterModel.isDefaultFilterModel;

  bool get isCustomFilterModel => !filterModel.isDefaultFilterModel;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  XFilterModel({required this.xShelf, required this.filterModel})
      : _xFilterModelId = __xFilterModelSeq++;

  bool isVisibleNeedToQuery() {
    if (isDefaultFilterModel) {
      return false;
    }
    if (!filterModel.ui.hasActiveUiComponent()) {
      return false;
    }
    if (filterModel.dataState == DataState.ready) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
