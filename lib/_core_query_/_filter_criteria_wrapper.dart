part of '../flutter_artist.dart';

class _FilterCriteriaWrapper<S extends FilterCriteria> {
  final int filterCriteriaId;
  final S filterCriteria;

  _FilterCriteriaWrapper({
    required this.filterCriteriaId,
    required this.filterCriteria,
  });
}
