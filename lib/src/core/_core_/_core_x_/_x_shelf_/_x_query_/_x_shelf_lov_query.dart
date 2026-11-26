part of '../../../core.dart';

class _XShelfLovQuery extends _XShelfBaseQuery {
  _XShelfLovQuery({
    required LovModel lovModel,
    required FilterPatch? filterPatch,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
  }) : super(
          xShelfType: XShelfType.lovQuery,
          shelf: lovModel.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: lovModel.ownedOrDefaultFilterModel,
      filterPatch: filterPatch,
      targetBlockAndOptions: null,
      targetScalarAndOptions: null,
      targetLovAndOptions: TargetLovAndOptions(
        lovModel: lovModel,
        queryType: QueryType.realQuery,
        listUpdateStrategy: listUpdateStrategy,
        pageable: pageable,
      ),
      forceQueryAll: false,
      forceReloadFilter: false,
    );
  }
}
