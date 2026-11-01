part of '../../../core.dart';

class _XShelfFilterModelQuery extends _XShelfBaseQuery {
  _XShelfFilterModelQuery({
    required FilterModel filterModel,
    required FilterPatch? filterPatch,
    required bool forceQueryAll,
  }) : super(
    xShelfType: XShelfType.filterModelQuery,
    shelf: filterModel.shelf,
  ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: filterModel,
      filterPatch: filterPatch,
      targetBlockAndOptions: null,
      targetScalarAndOptions: null,
      forceQueryAll: forceQueryAll,
      forceReloadFilter: true,
    );
  }
}
