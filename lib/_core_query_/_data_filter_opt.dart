part of '../flutter_artist.dart';

///
/// DataFilter with Query Options
///
class _DataFilterOpt {
  final DataFilter dataFilter;
  final SuggestedCriteria? suggestedCriteria;

  _DataFilterOpt({
    required this.dataFilter,
    required this.suggestedCriteria,
  }) {
    if (suggestedCriteria != null) {
      assert(dataFilter.getFilterCriteriaTypeAsString() ==
          suggestedCriteria.runtimeType.toString());
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(dataFilter)})";
  }
}
