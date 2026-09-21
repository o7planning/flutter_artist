part of '../../../core.dart';

class _XShelfShelfNaturalQuery extends _XShelfBaseQuery {
  _XShelfShelfNaturalQuery({
    required super.shelf,
  }) : super(
          xShelfType: XShelfType.naturalQuery,
        ) {
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
              xScalar.scalar.dataState.isStale) {
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
        //
        bool blockVisibleX = xBlock.block.ui.hasBlockContext(
          includeDescendants: true,
        );
        if (blockVisibleX) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isStale) {
            xBlock.setQueryHintToGreater(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;
        if (xFormModel != null && xFormModel.formModel.ui.hasVisibleViews()) {
          if (xFormModel.formModel.dataState.isPending ||
              xFormModel.formModel.dataState.isFatalError ||
              xFormModel.formModel.dataState.isNone) {
            // Test case: [39b]
            if (naturalMode) {
              xFormModel.setForceType(FormForceType.auto);
            } else {
              xFormModel.setForceType(FormForceType.force);
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }
}
