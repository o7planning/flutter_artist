part of '../../core.dart';

class _XShelfShelfExternalReaction extends XShelf {
  _XShelfShelfExternalReaction({
    required super.shelf,
    required EffectedShelfMembers effectedShelfMembers,
  }) : super(xShelfType: XShelfType.shelfExternalReaction) {
    Set<String> listenerBlockNames = {}
      ..addAll(effectedShelfMembers._reQueryBlockMAP.keys)
      ..addAll(effectedShelfMembers._refreshCurrItmBlockMAP.keys);

    for (String listenerBlkName in listenerBlockNames) {
      final Block? reQryBlock =
          effectedShelfMembers._reQueryBlockMAP[listenerBlkName];
      final Block? refreshCurrBlock =
          effectedShelfMembers._refreshCurrItmBlockMAP[listenerBlkName];
      //
      bool blockVisible = false;
      QryHint queryHint = QryHint.none;
      bool forceReloadItem = false;
      //
      if (reQryBlock != null) {
        blockVisible = reQryBlock.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        queryHint = blockVisible ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        blockVisible = refreshCurrBlock.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        forceReloadItem = true;
      }
      //
      XBlock xBlock = xBlockMap[listenerBlkName]!;
      xBlock.setQueryHint(queryHint);
      xBlock.setForceReloadCurrItem(forceReloadItem);
    }
    //
    for (Scalar s in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = s.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool hasActiveUI = s.ui.hasActiveUIComponent();
      if (hasActiveUI) {
        // Test Cases: [84a].
        xScalar.setQueryHint(QryHint.force);
      } else {
        // Test Cases: [84b].
        xScalar.setQueryHint(QryHint.markAsPending);
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (true) {
        if (xBlock == null) {
          break;
        }
        bool hasXActiveUI = xBlock.block.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (xBlock.block.dataState == DataState.pending ||
              xBlock.block.dataState == DataState.error) {
            xBlock.setQueryHint(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;
        // Current: forShelfExternalReaction
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.dataState == DataState.pending ||
              xFormModel.formModel.dataState == DataState.error ||
              xFormModel.formModel.dataState == DataState.none) {
            xFormModel.lazy = true;
            if (naturalMode) {
              xFormModel.setForceType(ForceType.decidedAtRuntime);
            } else {
              xFormModel.setForceType(ForceType.force);
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }
}
