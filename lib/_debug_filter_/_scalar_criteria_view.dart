part of '../flutter_artist.dart';

class _ScalarCriteriaView extends _BlkOrScrCriteriaView {
  final Scalar scalar;

  _ScalarCriteriaView({required this.scalar});

  @override
  String getBlockOrScalarClassName() {
    return getClassName(scalar);
  }

  @override
  String? getDataFilterClassName() {
    DataFilter? dataFilter = scalar.dataFilter;
    return dataFilter == null ? null : getClassName(dataFilter);
  }

  @override
  FilterCriteria? getFilterCriteria() {
     return scalar.data.filterCriteria;
  }

}
