part of '../../../core.dart';

class _XShelfShelfExternalReaction extends _XShelfSbQuery {
  _XShelfShelfExternalReaction({
    required super.shelf,
  }) : super(
          xShelfType: XShelfType.shelfExternalReaction,
        ) {
    for (XBlock xBlk in allXBlocks) {
      if (xBlk.block._blockSyncSessionState == null &&
          xBlk.block._blockItemRefreshCondition == null) {
        continue;
      }
      // @@@hasActiveBlockFragment
      bool blockXBlockRep =
          xBlk.block.ui.hasActiveUiComponentBlockRepresentative(
        alsoCheckChildren: true,
      );
      print(
          "~~~~~~~~~~~~~~~~> _XShelfShelfExternalReaction / ${xBlk.block} - blockXBlockRep: $blockXBlockRep");
      QryHint queryHint = QryHint.none;
      bool forceReloadItem = false;
      //
      if (xBlk.block._blockSyncSessionState != null &&
          xBlk.block._isMatchBlockReQryCon(xBlk.block._blockSyncSessionState)) {
        print("@TEMP: *** CURRENT block state ***: ${xBlk.block.dataState}");
        // queryHint = blockXBlockRep ? QryHint.force : QryHint.markAsPending;
        if (blockXBlockRep) {
          queryHint = QryHint.force;
        }
      }
      if (xBlk.block._blockItemRefreshCondition != null &&
          xBlk.block._isMatchBlockItemRefreshCon(
              xBlk.block._blockItemRefreshCondition)) {
        forceReloadItem = true;
      }
      //
      xBlk.setQueryHintToGreater(queryHint);
      xBlk.setForceReloadCurrItem(forceReloadItem);
    }
    // -------------------------------------------------------------------------
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (true) {
        if (xBlock == null) {
          break;
        }
        // @@@hasActiveBlockFragment
        bool blockXBlockRep =
            xBlock.block.ui.hasActiveUiComponentBlockRepresentative(
          alsoCheckChildren: true,
        );
        if (blockXBlockRep) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isStale) {
            xBlock.setQueryHintToGreater(QryHint.force);
          }
        }
        // Descendant Blocks with the same FilterModel:
        // Shared FilterModel.
        List<Block> descendantSFMBlocks =
            xBlock.block.descendantBlocksWithSameFilterModel;
        for (Block descendantBlock in descendantSFMBlocks) {
          XBlock descendantXBlock = xBlockMap[descendantBlock.name]!;
          if (descendantXBlock.queryHint == QryHint.force) {
            // Search: LOGIC-02.??
            // xBlock.setQueryHintToGreater(QryHint.force);
            // break;
            // Test Cases: [65a].
            if (xBlock.block.dataState.isPending ||
                xBlock.block.dataState.isStale) {
              xBlock.setQueryHintToGreater(QryHint.force);
              break;
            }
          }
        }
        //
        XFormModel? xFormModel = xBlock.xFormModel;
        // Current: forShelfExternalReaction
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUiComponent()) {
          if (xFormModel.formModel.dataState.isPending ||
              xFormModel.formModel.dataState.isFatalError ||
              xFormModel.formModel.dataState.isNone) {
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
    // -------------------------------------------------------------------------
    for (XScalar xScalar in allXScalars) {
      if (xScalar.scalar._scalarSyncSessionState == null) {
        continue;
      }
      bool scalarXVisible = xScalar.scalar.ui.hasActiveUiComponent(
        alsoCheckChildren: true,
      );
      QryHint queryHint = QryHint.none;
      //
      if (xScalar.scalar._scalarSyncSessionState != null &&
          xScalar.scalar
              ._isMatchScalarReQryCon(xScalar.scalar._scalarSyncSessionState)) {
        if (scalarXVisible) {
          // Test Cases: [84a].
          xScalar.setQueryHintToGreater(QryHint.force);
        }
      }
      xScalar.setQueryHintToGreater(queryHint);
    }
    // -------------------------------------------------------------------------
    for (XScalar leafXScalar in allLeafXScalars) {
      XScalar? xScalar = leafXScalar;
      while (true) {
        if (xScalar == null) {
          break;
        }
        bool hasXActiveUI = xScalar.scalar.ui.hasActiveScalarBaseView(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (xScalar.scalar.dataState.isPending ||
              xScalar.scalar.dataState.isStale) {
            xScalar.setQueryHintToGreater(QryHint.force);
          }
        }
        // Descendant Scalars with the same FilterModel:
        // Shared FilterModel.
        List<Scalar> descendantSFMScalars =
            xScalar.scalar.descendantScalarsWithSameFilterModel;
        for (Scalar descendantScalar in descendantSFMScalars) {
          XScalar descendantXScalar = xScalarMap[descendantScalar.name]!;
          if (descendantXScalar.queryHint == QryHint.force) {
            // Search: LOGIC-02.
            // xScalar.setQueryHintToGreater(QryHint.force);
            // break;
            // Test Cases:
            if (xScalar.scalar.dataState.isPending ||
                xScalar.scalar.dataState.isStale) {
              xScalar.setQueryHintToGreater(QryHint.force);
              break;
            }
          }
        }
        //
        xScalar = xScalar.parentXScalar;
      }
    }
  }
}
