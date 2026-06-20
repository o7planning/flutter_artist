part of '../../../core.dart';

class _XShelfBlockQueryEmpty extends _XShelfSbQuery {
  _XShelfBlockQueryEmpty({
    required Block block,
    required FilterInput? filterInput,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
    required BlockAfterQueryDirective? afterQueryDirective,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQueryEmpty,
          shelf: block.shelf,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: block.registeredOrDefaultFilterModel,
      filterInput: filterInput,
      srcBlockAndOptions: SrcBlockAndOptions(
        block: block,
        queryType: QueryType.emptyQuery,
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
