part of '../flutter_artist.dart';

class _XDataFilter {
  bool needQuery = false;
  final DataFilter dataFilter;
  FilterSnapshot? suggestedFilterSnapshot;

  _XDataFilter({
    required this.dataFilter,
  });

  String get name => dataFilter.name;
}
