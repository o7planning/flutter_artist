part of '../../core.dart';

class _XShelfBlockSilentActionExecution extends XShelf {
  _XShelfBlockSilentActionExecution({
    required Block block,
    required FilterInput? filterInput,
    required AfterBlockSilentAction afterSilentAction,
  }) : super(
          xShelfType: XShelfType.blockSilentActionExecution,
          shelf: block.shelf,
        ) {
    QryHint queryHint = QryHint.none;
    bool forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    switch (afterSilentAction) {
      case AfterBlockSilentAction.none:
        break;
      case AfterBlockSilentAction.refreshCurrentItem:
        // Test Cases: [62a].
        forceReloadItem = true;
        break;
      case AfterBlockSilentAction.query:
        queryHint = QryHint.force;
        forceReloadItem = false;
    }
    //
    thisXBlock.setQueryHintToGreater(queryHint);
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    if (forceReloadItem) {
      thisXBlock.setCandidateCurrItem(thisXBlock.block.currentItem);
    }
    //
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      itemListMode: null,
      suggestedSelection: null,
      postQueryBehavior: null,
      pageable: null,
    );
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
    thisXBlock.xShelf.printInfo();
  }
}
