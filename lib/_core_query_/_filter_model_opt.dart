part of '../flutter_artist.dart';

///
/// DataFilter with Query Options
///
class _FilterModelOpt {
  final FilterModel dataFilter;
  final FilterInput? filterInput;

  _FilterModelOpt({
    required this.dataFilter,
    required this.filterInput,
  }) {
    if (filterInput != null) {
      assert(dataFilter.getFilterInputTypeAsString() ==
          filterInput.runtimeType.toString());
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(dataFilter)})";
  }
}
