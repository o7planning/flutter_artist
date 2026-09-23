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
            xScalar.setQueryHintToGreater(QueryHint.force);
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
            xBlock.setQueryHintToGreater(QueryHint.force);
          }
        }
        XBlockFormModel? xBlockFormModel = xBlock.xBlockFormModel;
        if (xBlockFormModel != null && xBlockFormModel.formModel.ui.hasVisibleViews()) {
          if (xBlockFormModel.formModel.dataState.isPending ||
              xBlockFormModel.formModel.dataState.isFatalError ||
              xBlockFormModel.formModel.dataState.isNone) {
            // Test case: [39b]
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
  }
}
