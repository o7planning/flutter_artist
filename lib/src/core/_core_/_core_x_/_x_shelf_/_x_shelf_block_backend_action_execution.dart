part of '../../core.dart';

class _XShelfBlockBackendActionExecution extends XShelf {
  _XShelfBlockBackendActionExecution({
    required Block block,
    required FilterInput? filterInput,
    required AfterBlockBackendAction afterBackendAction,
  }) : super(
          xShelfType: XShelfType.blockBackendActionExecution,
          shelf: block.shelf,
        ) {
    QryHint queryHint = QryHint.none;
    bool forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    switch (afterBackendAction) {
      case AfterBlockBackendAction.none:
        break;
      case AfterBlockBackendAction.query:
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
      listUpdateStrategy: null,
      suggestedSelection: null,
      afterQueryAction: null,
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
