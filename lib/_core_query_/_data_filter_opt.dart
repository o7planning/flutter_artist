part of '../flutter_artist.dart';

///
/// DataFilter with Query Options
///
class _DataFilterOpt {
  final DataFilter dataFilter;
  final FilterSnapshot? suggestedFilterSnapshot;

  _DataFilterOpt({
    required this.dataFilter,
    required this.suggestedFilterSnapshot,
  }) {
    if (suggestedFilterSnapshot != null) {
      assert(dataFilter.getFilterSnapshotTypeAsString() ==
          suggestedFilterSnapshot.runtimeType.toString());
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(dataFilter)})";
  }
}
