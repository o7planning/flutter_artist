part of '../../../core.dart';

class _XShelfSbQuery extends XShelf {
  _XShelfSbQuery({
    required super.xShelfType,
    required super.shelf,
  });

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _updateQueryStateFromFilterModelAndFilterInput({
    required SrcBlockAndOptions? srcBlockAndOptions,
    required SrcScalarAndOptions? srcScalarAndOptions,
    required FilterModel filterModel,
    required FilterInput? filterInput,
  }) {
    if (filterModel.isDefaultFilterModel) {
      // return;
    }
    //
    final thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel.filterInput = filterInput;
    //
    if (srcBlockAndOptions != null) {
      final Block srcBlock = srcBlockAndOptions.block;
      final XBlock srcXBlock = xBlockMap[srcBlock.name]!;
      srcXBlock.setQueryHintToGreater(QryHint.force);
      srcXBlock.setOptions(
        queryType: srcBlockAndOptions.queryType,
        itemListMode: srcBlockAndOptions.itemListMode,
        suggestedSelection: srcBlockAndOptions.suggestedSelection,
        postQueryBehavior: srcBlockAndOptions.postQueryBehavior,
        pageable: srcBlockAndOptions.pageable,
      );
      setRootVipXBlock(descendantXBlock: srcXBlock);
    }
    if (srcScalarAndOptions != null) {
      Scalar srcScalar = srcScalarAndOptions.scalar;
      XScalar srcXScalar = xScalarMap[srcScalar.name]!;
      srcXScalar.setQueryHintToGreater(QryHint.force);
      srcXScalar.setOptions(
        queryType: srcScalarAndOptions.queryType,
      );
      setRootVipXScalar(descendantXScalar: srcXScalar);
    }
    //
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      final Block block = xBlock.block;
      QryHint queryHint = QryHint.markAsPending;
      if (srcBlockAndOptions != null) {
        final Block srcBlock = srcBlockAndOptions.block;

        if (srcBlock.isSameWith(block)) {
          // No need to review Ancestors??
          continue;
        }
        // Search: LOGIC-02.
        if (block.isAncestorOf(srcBlock)) {
          queryHint = QryHint.force;
        }
      }
      bool hasXActiveUI = block.ui.hasActiveUIComponent(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        queryHint = QryHint.force;
      }
      //
      xBlock.setQueryHintToGreater(queryHint);
      // Set Default Options. They will be replaced if need.
      xBlock.setOptions(
        queryType: QueryType.realQuery,
        itemListMode: ItemListMode.replace,
        suggestedSelection: null,
        postQueryBehavior: null,
        pageable: null,
      );
      //
      if (queryHint == QryHint.force) {
        XBlock? parentXBlock = xBlock.parentXBlock;
        while (true) {
          if (parentXBlock == null) {
            break;
          }
          // @@@hasActiveBlockFragment
          final hasXActiveUI = parentXBlock.block.ui.hasActiveUIComponent(
            alsoCheckChildren: true,
          );
          if (hasXActiveUI) {
            if (parentXBlock.block.dataState == DataState.pending ||
                parentXBlock.block.dataState == DataState.error) {
              parentXBlock.setQueryHintToGreater(QryHint.force);
            }
          }
          // TODO: Need? Remove this code?
          // XFormModel? parentXFormModel = parentXBlock.xFormModel;
          // if (parentXFormModel != null &&
          //     parentXFormModel.formModel.ui.hasActiveUIComponent()) {
          //   if (parentXFormModel.formModel.dataState == DataState.pending ||
          //       parentXFormModel.formModel.dataState == DataState.error ||
          //       parentXFormModel.formModel.dataState == DataState.none) {
          //     parentXFormModel.setForceType(ForceType.decidedAtRuntime);
          //   }
          // }
          //
          parentXBlock = parentXBlock.parentXBlock;
        }
      }
    }
    for (XScalar xScalar in thisXFilterModel.xScalars) {
      final Scalar scalar = xScalar.scalar;
      QryHint queryHint = QryHint.markAsPending;
      if (srcScalarAndOptions != null) {
        final Scalar srcScalar = srcScalarAndOptions.scalar;
        if (srcScalar.isSameWith(scalar)) {
          // No need to review Ancestors??
          continue;
        }
        // Search: LOGIC-02.
        if (scalar.isAncestorOf(srcScalar)) {
          queryHint = QryHint.force;
        }
      }
      bool hasXActiveUI = scalar.ui.hasActiveUIComponent(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        queryHint = QryHint.force;
      }
      //
      xScalar.setQueryHintToGreater(queryHint);
      // Set Default Options. They will be replaced if need.
      xScalar.setOptions(
        queryType: QueryType.realQuery,
      );
      //
      if (queryHint == QryHint.force) {
        XScalar? parentXScalar = xScalar.parentXScalar;
        while (true) {
          if (parentXScalar == null) {
            break;
          }
          //
          final hasXActiveUI = parentXScalar.scalar.ui.hasActiveScalarFragment(
            alsoCheckChildren: true,
          );
          if (hasXActiveUI) {
            if (parentXScalar.scalar.dataState == DataState.pending ||
                parentXScalar.scalar.dataState == DataState.error) {
              parentXScalar.setQueryHintToGreater(QryHint.force);
            }
          }
          //
          parentXScalar = parentXScalar.parentXScalar;
        }
      }
    }
  }
}
