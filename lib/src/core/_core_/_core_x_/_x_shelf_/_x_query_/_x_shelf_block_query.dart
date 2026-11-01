part of '../../../core.dart';

class _XShelfBlockQuery extends _XShelfBaseQuery {
  _XShelfBlockQuery({
    required Block block,
    required FilterPatch? filterPatch,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
    required BlockAfterQueryDirective? afterQueryDirective,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQuery,
          shelf: block.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: block.registeredOrDefaultFilterModel,
      filterPatch: filterPatch,
      targetBlockAndOptions: TargetBlockAndOptions(
        block: block,
        queryType: QueryType.realQuery,
        listUpdateStrategy: listUpdateStrategy,
        suggestedSelection: suggestedSelection,
        afterQueryDirective: afterQueryDirective,
        pageable: pageable,
      ),
      targetScalarAndOptions: null,
      forceQueryAll: false,
      forceReloadFilter: false,
    );
  }
}
