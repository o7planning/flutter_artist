part of '../_fa_core.dart';

class _ScalarCriteriaView extends _BlkOrScrCriteriaView {
  final Scalar scalar;

  _ScalarCriteriaView({required this.scalar});

  @override
  String getBlockOrScalarClassName() {
    return getClassName(scalar);
  }

  @override
  String? getFilterModelClassName() {
    FilterModel? filterModel = scalar.filterModel;
    return filterModel == null ? null : getClassName(filterModel);
  }

  @override
  FilterCriteria? getFilterCriteria() {
    return scalar.filterCriteria;
  }
}
