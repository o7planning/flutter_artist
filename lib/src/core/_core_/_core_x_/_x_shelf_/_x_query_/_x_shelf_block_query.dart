part of '../../../core.dart';

class _XShelfBlockQuery extends _XShelfSbQuery {
  _XShelfBlockQuery({
    required Block block,
    required FilterInput? filterInput,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
    required BlockAfterQueryDirective? afterQueryDirective,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQuery,
          shelf: block.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: block.registeredOrDefaultFilterModel,
      filterInput: filterInput,
      srcBlockAndOptions: SrcBlockAndOptions(
        block: block,
        queryType: QueryType.realQuery,
        listUpdateStrategy: listUpdateStrategy,
        suggestedSelection: suggestedSelection,
        afterQueryDirective: afterQueryDirective,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
      forceQueryAll: false,
    );
  }
}
