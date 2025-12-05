part of '../../../core.dart';

class _XShelfBlockQuery extends _XShelfSbQuery {
  _XShelfBlockQuery({
    required Block block,
    required FilterInput? filterInput,
    required Pageable? pageable,
    required ItemListMode? itemListMode,
    required AfterQueryAction? afterQueryAction,
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
        itemListMode: itemListMode,
        suggestedSelection: suggestedSelection,
        afterQueryAction: afterQueryAction,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
      forceQueryAll: false,
    );
  }
}
