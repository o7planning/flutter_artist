part of '../flutter_artist.dart';

///
/// DataFilter with Query Options
///
class _DataFilterOpt {
  final DataFilter dataFilter;
  final FilterInput? filterInput;

  _DataFilterOpt({
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
