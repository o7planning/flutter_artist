part of '../../../core.dart';

class _XShelfBlockQuery extends _XShelfSbQuery {
  _XShelfBlockQuery({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ItemListMode? itemListMode,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQuery,
          shelf: block.shelf,
          resetReactionTypeToExternal: true,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: block.registeredOrDefaultFilterModel,
      filterInput: filterInput,
      srcBlockAndOptions: SrcBlockAndOptions(
        block: block,
        queryType: QueryType.realQuery,
        itemListMode: itemListMode,
        suggestedSelection: suggestedSelection,
        postQueryBehavior: postQueryBehavior,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
    );
  }
}
