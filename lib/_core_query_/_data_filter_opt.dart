part of '../flutter_artist.dart';

///
/// DataFilter with Query Options
///
class _DataFilterOpt {
  final DataFilter dataFilter;
  final SuggestedFilterData? suggestedFilterData;

  _DataFilterOpt({
    required this.dataFilter,
    required this.suggestedFilterData,
  }) {
    if (suggestedFilterData != null) {
      assert(dataFilter.getEmptyFilterCriteriaTypeAsString() ==
          suggestedFilterData.runtimeType.toString());
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(dataFilter)})";
  }
}
