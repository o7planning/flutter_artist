part of '../../../core.dart';

class _XShelfBlockQueryThenPrepareToCreate extends XShelf {
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
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    //
    XBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragment(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.dataState == DataState.pending ||
            parentXBlock.block.dataState == DataState.error) {
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.dataState == DataState.pending ||
            parentXFormModel.formModel.dataState == DataState.error ||
            parentXFormModel.formModel.dataState == DataState.none) {
          parentXFormModel.setForceType(ForceType.decidedAtRuntime);
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
