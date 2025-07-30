part of '../../_fa_core.dart';

class _XFilterModel {
  final _XShelf xShelf;

  bool queried = false;
  final FilterModel filterModel;
  FilterInput? filterInput;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  _XFilterModel({
    required this.xShelf,
    required this.filterModel,
  });

  @override
  String toString() {
    return "${getClassName(filterModel)} - queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
