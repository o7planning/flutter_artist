part of '../../core.dart';

class _XShelfBlockBackendActionExecution extends XShelf {
  _XShelfBlockBackendActionExecution({
    required Block block,
    required FilterInput? filterInput,
    required BlockViewportSyncStrategy? viewportSyncStrategy,
  }) : super(
    xShelfType: XShelfType.blockBackendActionExecution,
    shelf: block.shelf,
  ) {
    // QueryHint queryHint = QueryHint.none;
    // bool forceReloadItem = false;
    // //
    // final thisXBlock = xBlockMap[block.name]!;
    // final xFilterModel = thisXBlock.xFilterModel;
    // xFilterModel.filterInput = filterInput;
    // //
    // switch (viewportSyncStrategy) {
    //   case null:
    //     break;
    //   case BlockViewportSyncStrategy.effectedAndViewportItemIdsQuery:
    //   case BlockViewportSyncStrategy.effectedItemIdsQuery:
    //   case BlockViewportSyncStrategy.nativeQuery:
    //     queryHint = QueryHint.force;
    //     forceReloadItem = false;
    // }
    // //
    // thisXBlock.setQueryHintToGreater(queryHint);
    // thisXBlock.setForceReloadCurrItem(forceReloadItem);
    // if (forceReloadItem) {
    //   // thisXBlock.setCandidateCurrItem(thisXBlock.block.currentItem);
    // }
    // //
    // thisXBlock.setOptions(
    //   queryType: QueryType.realQuery,
    //   listUpdateStrategy: null,
    //   suggestedSelection: null,
    //   afterQueryDirective: null,
    //   pageable: null,
    // );
  }
}
