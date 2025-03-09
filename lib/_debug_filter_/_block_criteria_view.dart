part of '../flutter_artist.dart';

class _BlockCriteriaView extends _BlkOrScrCriteriaView {
  final Block block;

  _BlockCriteriaView({required this.block});

  @override
  String getBlockOrScalarClassName() {
    return getClassName(block);
  }

  @override
  String? getFilterModelClassName() {
    FilterModel? dataFilter = block.dataFilter;
    return dataFilter == null ? null : getClassName(dataFilter);
  }

  @override
  FilterCriteria? getFilterCriteria() {
    return block.data.filterCriteria;
  }
}
