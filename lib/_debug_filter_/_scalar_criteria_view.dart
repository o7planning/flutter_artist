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
  String? getFilterCriteriaClassName() {
    return scalar.getFilterCriteriaTypeAsString();
  }

  @override
  List<String> getFilterCriteriaDebugInfo() {
    FilterCriteria? criteria = scalar.data.filterCriteria;
    return criteria?.getDebugInfos() ?? [];
  }
}
