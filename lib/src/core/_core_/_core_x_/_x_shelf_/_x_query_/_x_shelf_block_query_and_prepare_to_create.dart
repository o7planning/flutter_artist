part of '../../../core.dart';

class _XShelfBlockQueryThenPrepareToCreate extends _XShelfSbQuery {
  _XShelfBlockQueryThenPrepareToCreate({
    required Block block,
    required FilterInput? filterInput,
    required Pageable? pageable,
    required ListUpdateStrategy? listUpdateStrategy,
    required AfterQueryAction? afterQueryAction,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQueryAndPrepareToCreate,
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
        afterQueryAction: afterQueryAction,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
      forceQueryAll: false,
    );
  }
}
