part of '../../../core.dart';

class _XShelfBlockQueryThenPrepareToEdit extends _XShelfSbQuery {
  _XShelfBlockQueryThenPrepareToEdit({
    required Block block,
    required FilterInput? filterInput,
    required Pageable? pageable,
    required ItemListMode? itemListMode,
    required AfterQueryAction? afterQueryAction,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQueryAndPrepareToEdit,
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
