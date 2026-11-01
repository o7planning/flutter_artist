part of '../../../core.dart';

class _XShelfBlockQueryEmpty extends _XShelfBaseQuery {
  _XShelfBlockQueryEmpty({
    required Block block,
    required FilterPatch? filterPatch,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
    required BlockAfterQueryDirective? afterQueryDirective,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
    xShelfType: XShelfType.blockQueryEmpty,
    shelf: block.shelf,
  ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: block.registeredOrDefaultFilterModel,
      filterPatch: filterPatch,
      targetBlockAndOptions: TargetBlockAndOptions(
        block: block,
        queryType: QueryType.emptyQuery,
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
