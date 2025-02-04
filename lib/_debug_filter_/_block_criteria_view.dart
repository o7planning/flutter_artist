part of '../flutter_artist.dart';

class _BlockCriteriaView extends _BlkOrScrCriteriaView {
  final Block block;

  _BlockCriteriaView({required this.block});

  @override
  String getBlockOrScalarClassName() {
    return getClassName(block);
  }

  @override
  String? getDataFilterClassName() {
    DataFilter? dataFilter = block.dataFilter;
    return dataFilter == null ? null : getClassName(dataFilter);
  }

  @override
  String? getFilterCriteriaClassName() {
    return block.getFilterCriteriaTypeAsString();
  }

  @override
  List<String> getFilterCriteriaDebugInfo() {
    FilterCriteria? criteria = block.data.filterCriteria;
    return criteria?.getDebugInfos() ?? [];
  }
}
