part of '../../../core.dart';

class _XShelfBlockQueryThenPrepareToEdit extends _XShelfBaseQuery {
  _XShelfBlockQueryThenPrepareToEdit({
    required Block block,
    required FilterPatch? filterPatch,
    required Pageable? pageable,
    required ListUpdateStrategy? suggestedListUpdateStrategy,
    required BlockAfterQueryDirective? afterQueryDirective,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
    xShelfType: XShelfType.blockQueryAndPrepareToEdit,
    shelf: block.shelf,
  ) {
    _updateQueryStateFromFilterModelAndFilterPatch(
      filterModel: block.registeredOrDefaultFilterModel,
      filterPatch: filterPatch,
      targetBlockAndOptions: TargetBlockAndOptions(
        block: block,
        queryType: QueryType.realQuery,
        listUpdateStrategy: suggestedListUpdateStrategy,
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
