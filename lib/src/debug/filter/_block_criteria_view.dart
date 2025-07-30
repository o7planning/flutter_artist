import '../../core/_core/code.dart';
import '../../core/utils/_class_utils.dart';
import '_blk_or_scr_criteria_view.dart';

class BlockCriteriaView extends BlkOrScrCriteriaView {
  final Block block;

  const BlockCriteriaView({super.key, required this.block});

  @override
  String getBlockOrScalarClassName() {
    return getClassName(block);
  }

  @override
  String? getFilterModelClassName() {
    FilterModel? filterModel = block.filterModel;
    return filterModel == null ? null : getClassName(filterModel);
  }

  @override
  FilterCriteria? getFilterCriteria() {
    return block.filterCriteria;
  }
}
