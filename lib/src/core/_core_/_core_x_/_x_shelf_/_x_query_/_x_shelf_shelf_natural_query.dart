part of '../../../core.dart';

class _XShelfShelfNaturalQuery extends _XShelfSbQuery {
  _XShelfShelfNaturalQuery({required super.shelf})
      : super(xShelfType: XShelfType.naturalQuery) {
    for (XScalar xScalar in allXScalars) {
      if (xScalar.scalar.ui.hasActiveUIComponent()) {
        if (xScalar.scalar.dataState == DataState.pending ||
            xScalar.scalar.dataState == DataState.error) {
          xScalar.setQueryHint(QryHint.force);
        }
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
