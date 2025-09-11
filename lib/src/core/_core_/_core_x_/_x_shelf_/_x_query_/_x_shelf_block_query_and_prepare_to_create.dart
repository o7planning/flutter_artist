part of '../../../core.dart';

class _XShelfBlockQueryThenPrepareToCreate extends _XShelfSbQuery {
  _XShelfBlockQueryThenPrepareToCreate({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
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
        listBehavior: listBehavior,
        suggestedSelection: suggestedSelection,
        postQueryBehavior: postQueryBehavior,
        pageable: pageable,
      ),
      srcScalarAndOptions: null,
    );
    //
    // final thisXBlock = xBlockMap[block.name]!;
    // final xFilterModel = thisXBlock.xFilterModel;
    // xFilterModel.filterInput = filterInput;
    // //
    // thisXBlock.setForceReloadCurrItem(false);
    // //
    // thisXBlock.setQueryHintToGreater(QryHint.force);
    // thisXBlock.setOptions(
    //   queryType: QueryType.realQuery,
    //   listBehavior: listBehavior,
    //   suggestedSelection: suggestedSelection,
    //   postQueryBehavior: postQueryBehavior,
    //   pageable: pageable,
    // );
    //
    // XBlock? parentXBlock = thisXBlock.parentXBlock;
    // while (true) {
    //   if (parentXBlock == null) {
    //     break;
    //   }
    //   //
    //   final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragment(
    //     alsoCheckChildren: true,
    //   );
    //   if (hasXActiveUI) {
    //     if (parentXBlock.block.dataState == DataState.pending ||
    //         parentXBlock.block.dataState == DataState.error) {
    //       parentXBlock.setQueryHint(QryHint.force);
    //     }
    //   }
    //   // TODO: Need? Remove this code?
    //   XFormModel? parentXFormModel = parentXBlock.xFormModel;
    //   if (parentXFormModel != null &&
    //       parentXFormModel.formModel.ui.hasActiveUIComponent()) {
    //     if (parentXFormModel.formModel.dataState == DataState.pending ||
    //         parentXFormModel.formModel.dataState == DataState.error ||
    //         parentXFormModel.formModel.dataState == DataState.none) {
    //       parentXFormModel.setForceType(ForceType.decidedAtRuntime);
    //     }
    //   }
    //   //
    //   parentXBlock = parentXBlock.parentXBlock;
    // }
    //
    // setRootVipXBlock(descendantXBlock: thisXBlock);
  }
}
