part of '../../../core.dart';

class _XShelfBlockQueryEmpty extends _XShelfSbQuery {
  _XShelfBlockQueryEmpty({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ItemListMode? itemListMode,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  }) : super(
          xShelfType: XShelfType.blockQueryEmpty,
          shelf: block.shelf,
          resetReactionTypeToExternal: true,
        ) {
    _updateQueryStateFromFilterModelAndFilterInput(
      filterModel: block.registeredOrDefaultFilterModel,
      filterInput: filterInput,
      srcBlockAndOptions: SrcBlockAndOptions(
        block: block,
        queryType: QueryType.emptyQuery,
        itemListMode: itemListMode,
        suggestedSelection: suggestedSelection,
        postQueryBehavior: postQueryBehavior,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
    );
  }
}
