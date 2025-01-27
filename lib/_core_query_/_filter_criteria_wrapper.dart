part of '../flutter_artist.dart';

@Deprecated("Khong su dung nua")
class _FilterCriteriaWrapper<S extends FilterCriteria> {
  final int filterCriteriaId;
  final S filterCriteria;

  _FilterCriteriaWrapper({
    required this.filterCriteriaId,
    required this.filterCriteria,
  });
}
