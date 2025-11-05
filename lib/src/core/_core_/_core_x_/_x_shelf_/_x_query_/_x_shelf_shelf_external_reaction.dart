part of '../../../core.dart';

class _XShelfShelfExternalReaction extends _XShelfSbQuery {
  _XShelfShelfExternalReaction({
    required super.shelf,
  }) : super(
          xShelfType: XShelfType.shelfExternalReaction,
        ) {
    for (XBlock xBlk in allXBlocks) {
      if (xBlk._blockReQryCon == null && xBlk._blockItemRefreshCon == null) {
        continue;
      }
      // @@@hasActiveBlockFragment
      bool blockXBlockRep =
          xBlk.block.ui.hasActiveUIComponentBlockRepresentative(
        alsoCheckChildren: true,
      );
      print(
          "~~~~~~~~~~~~~~~~> _XShelfShelfExternalReaction / ${xBlk.block} - blockXBlockRep: $blockXBlockRep");
      QryHint queryHint = QryHint.none;
      bool forceReloadItem = false;
      //
      if (xBlk._blockReQryCon != null &&
          xBlk.block._isMatchBlockReQryCon(xBlk._blockReQryCon)) {
        queryHint = blockXBlockRep ? QryHint.force : QryHint.markAsPending;
      }
      if (xBlk._blockItemRefreshCon != null &&
          xBlk.block._isMatchBlockItemRefreshCon(xBlk._blockItemRefreshCon)) {
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
            xBlock.block.ui.hasActiveUIComponentBlockRepresentative(
          alsoCheckChildren: true,
        );
        if (blockXBlockRep) {
          if (xBlock.block.dataState == DataState.pending ||
              xBlock.block.dataState == DataState.error) {
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
            if (xBlock.block.dataState == DataState.pending ||
                xBlock.block.dataState == DataState.error) {
              xBlock.setQueryHintToGreater(QryHint.force);
              break;
            }
          }
        }
        //
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
    // -------------------------------------------------------------------------
    for (XScalar xScalar in allXScalars) {
      if (xScalar._scalarReQryCon == null) {
        continue;
      }
      bool scalarXVisible = xScalar.scalar.ui.hasActiveUIComponent(
        alsoCheckChildren: true,
      );
      //
      if (xScalar.scalar._isMatchScalarReQryCon(xScalar._scalarReQryCon)) {
        if (scalarXVisible) {
          // Test Cases: [84a].
          xScalar.setQueryHintToGreater(QryHint.force);
        } else {
          // Test Cases: [84b].
          xScalar.setQueryHintToGreater(QryHint.markAsPending);
        }
      }
    }
    // -------------------------------------------------------------------------
    for (XScalar leafXScalar in allLeafXScalars) {
      XScalar? xScalar = leafXScalar;
      while (true) {
        if (xScalar == null) {
          break;
        }
        bool hasXActiveUI = xScalar.scalar.ui.hasActiveScalarPiece(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (xScalar.scalar.dataState == DataState.pending ||
              xScalar.scalar.dataState == DataState.error) {
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
            if (xScalar.scalar.dataState == DataState.pending ||
                xScalar.scalar.dataState == DataState.error) {
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
