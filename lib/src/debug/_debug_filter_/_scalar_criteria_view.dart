import '../../core/_fa_core.dart';
import '_blk_or_scr_criteria_view.dart';

class ScalarCriteriaView extends BlkOrScrCriteriaView {
  final Scalar scalar;

  ScalarCriteriaView({required this.scalar});

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
