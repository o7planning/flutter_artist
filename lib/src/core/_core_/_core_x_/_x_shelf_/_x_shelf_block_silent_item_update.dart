part of '../../core.dart';

class _XShelfBlockSilentItemUpdate extends XShelf {
  _XShelfBlockSilentItemUpdate({
    required Block block,
    required AfterBlockSilentAction afterSilentAction,
  }) : super(
          xShelfType: XShelfType.blockSilentItemUpdate,
          shelf: block.shelf,
        ) {
    QryHint queryHint = QryHint.none;
    bool forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
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
      listBehavior: null,
      suggestedSelection: null,
      postQueryBehavior: null,
      pageable: null,
    );
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
