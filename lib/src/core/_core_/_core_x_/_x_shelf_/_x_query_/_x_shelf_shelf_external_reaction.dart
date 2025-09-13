part of '../../../core.dart';

class _XShelfShelfExternalReaction extends _XShelfSbQuery {
  _XShelfShelfExternalReaction({
    required super.shelf,
    required EffectedShelfMembers effectedShelfMembers,
  }) : super(xShelfType: XShelfType.shelfExternalReaction) {
    Set<String> listenerBlockNames = {}
      ..addAll(effectedShelfMembers._reQueryBlockMAP.keys)
      ..addAll(effectedShelfMembers._refreshCurrItmBlockMAP.keys);
    // -------------------------------------------------------------------------
    for (String listenerBlkName in listenerBlockNames) {
      final Block? reQryBlock =
          effectedShelfMembers._reQueryBlockMAP[listenerBlkName];
      final Block? refreshCurrBlock =
          effectedShelfMembers._refreshCurrItmBlockMAP[listenerBlkName];
      //
      bool blockXVisible = false;
      QryHint queryHint = QryHint.none;
      bool forceReloadItem = false;
      //
      if (reQryBlock != null) {
        blockXVisible = reQryBlock.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        queryHint = blockXVisible ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        blockXVisible = refreshCurrBlock.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        forceReloadItem = true;
      }
      //
      XBlock xBlock = xBlockMap[listenerBlkName]!;
      xBlock.setQueryHintToGreater(queryHint);
      xBlock.setForceReloadCurrItem(forceReloadItem);
    }
    // -------------------------------------------------------------------------
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
    for (Scalar scalar in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = scalar.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool scalarXVisible = scalar.ui.hasActiveUIComponent(
        alsoCheckChildren: true,
      );
      if (scalarXVisible) {
        // Test Cases: [84a].
        xScalar.setQueryHintToGreater(QryHint.force);
      } else {
        // Test Cases: [84b].
        xScalar.setQueryHintToGreater(QryHint.markAsPending);
      }
    }
    // -------------------------------------------------------------------------
    for (XScalar leafXScalar in allLeafXScalars) {
      XScalar? xScalar = leafXScalar;
      while (true) {
        if (xScalar == null) {
          break;
        }
        bool hasXActiveUI = xScalar.scalar.ui.hasActiveScalarFragment(
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
