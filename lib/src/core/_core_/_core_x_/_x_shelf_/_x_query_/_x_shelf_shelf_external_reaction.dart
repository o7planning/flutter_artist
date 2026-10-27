part of '../../../core.dart';

class _XShelfShelfExternalReaction extends _XShelfBaseQuery {
  _XShelfShelfExternalReaction({
    required super.shelf,
  }) : super(
          xShelfType: XShelfType.shelfExternalReaction,
        ) {
    for (XBlock xBlk in allXBlocks) {
      if (xBlk.block._blockSyncSessionState == null &&
          xBlk.block.blockCurrentItemModel._blockItemSyncSessionState == null) {
        continue;
      }
      //
      bool blockXBlockRep = xBlk.block.ui.hasBlockContext(
        includeDescendants: true,
      );
      QueryHint queryHint = QueryHint.none;
      bool forceReloadItem = false;
      //
      if (xBlk.block._blockSyncSessionState != null &&
          xBlk.block._isMatchBlockSyncSessionState(
              xBlk.block._blockSyncSessionState)) {
        if (blockXBlockRep) {
          queryHint = QueryHint.force;
        }
      }
      if (xBlk.block.blockCurrentItemModel._blockItemSyncSessionState != null &&
          xBlk.block.blockCurrentItemModel._blockItemSyncSessionState!
              .isValidFor(xBlk.block.currentItemId)) {
        forceReloadItem = true;
      }
      //
      xBlk.setQueryHintToGreater(queryHint);
      xBlk.xBlockCurrentItemModel.setForceReloadCurrItem(forceReloadItem);
    }
    // -------------------------------------------------------------------------
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (true) {
        if (xBlock == null) {
          break;
        }
        // @@@hasActiveBlockFragment
        bool blockXBlockRep = xBlock.block.ui.hasBlockContext(
          includeDescendants: true,
        );
        if (blockXBlockRep) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isLoadedStale) {
            xBlock.setQueryHintToGreater(QueryHint.force);
          }
        }
        // Descendant Blocks with the same FilterModel:
        // Shared FilterModel.
        List<Block> descendantSFMBlocks =
            xBlock.block.descendantBlocksWithSameFilterModel;
        for (Block descendantBlock in descendantSFMBlocks) {
          XBlock descendantXBlock = xBlockMap[descendantBlock.name]!;
          if (descendantXBlock.queryHint == QueryHint.force) {
            // Search: LOGIC-02.??
            // xBlock.setQueryHintToGreater(QueryHint.force);
            // break;
            // Test Cases: [65a].
            if (xBlock.block.dataState.isPending ||
                xBlock.block.dataState.isLoadedStale) {
              xBlock.setQueryHintToGreater(QueryHint.force);
              break;
            }
          }
        }
        //
        XBlockFormModel? xBlockFormModel =
            xBlock.xBlockCurrentItemModel.xBlockFormModel;
        // Current: forShelfExternalReaction
        if (xBlockFormModel != null &&
            xBlockFormModel.formModel.ui.hasVisibleViews()) {
          if (xBlockFormModel.formModel.dataState.isPending ||
              xBlockFormModel.formModel.dataState.isFatalError ||
              xBlockFormModel.formModel.dataState.isNone) {
            if (naturalMode) {
              xBlockFormModel.setForceType(FormLoadHint.auto);
            } else {
              xBlockFormModel.setForceType(FormLoadHint.force);
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
      bool scalarXVisible = xScalar.scalar.ui.hasVisibleViews(
        includeDescendants: true,
      );
      QueryHint queryHint = QueryHint.none;
      //
      if (xScalar.scalar._scalarSyncSessionState != null &&
          xScalar.scalar._isMatchScalarSyncSessionState(
              xScalar.scalar._scalarSyncSessionState)) {
        if (scalarXVisible) {
          // Test Cases: [84a].
          xScalar.setQueryHintToGreater(QueryHint.force);
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
        bool hasXActiveUI = xScalar.scalar.ui.hasVisibleContentView(
          includeDescendants: true,
        );
        if (hasXActiveUI) {
          if (xScalar.scalar.dataState.isPending ||
              xScalar.scalar.dataState.isLoadedStale) {
            xScalar.setQueryHintToGreater(QueryHint.force);
          }
        }
        // Descendant Scalars with the same FilterModel:
        // Shared FilterModel.
        List<Scalar> descendantSFMScalars =
            xScalar.scalar.descendantScalarsWithSameFilterModel;
        for (Scalar descendantScalar in descendantSFMScalars) {
          XScalar descendantXScalar = xScalarMap[descendantScalar.name]!;
          if (descendantXScalar.queryHint == QueryHint.force) {
            // Search: LOGIC-02.
            // xScalar.setQueryHintToGreater(QueryHint.force);
            // break;
            // Test Cases:
            if (xScalar.scalar.dataState.isPending ||
                xScalar.scalar.dataState.isLoadedStale) {
              xScalar.setQueryHintToGreater(QueryHint.force);
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
