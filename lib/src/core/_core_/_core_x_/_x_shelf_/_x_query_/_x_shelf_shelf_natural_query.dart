part of '../../../core.dart';

class _XShelfShelfNaturalQuery extends _XShelfSbQuery {
  _XShelfShelfNaturalQuery({required super.shelf})
      : super(
          xShelfType: XShelfType.naturalQuery,
        ) {
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
        xScalar = xScalar.parentXScalar;
      }
    }
    //
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
        XFormModel? xFormModel = xBlock.xFormModel;
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
