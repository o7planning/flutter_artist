part of '../../../core.dart';

class _XShelfBaseQuery extends XShelf {
  _XShelfBaseQuery({
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
    required bool forceQueryAll,
    required bool forceReloadFilter,
  }) {
    assert(!forceQueryAll ||
        (srcBlockAndOptions == null && srcScalarAndOptions == null));
    //
    if (filterModel.isDefaultFilterModel) {
      // Do Nothing.
    }
    //
    final thisXFilterModel = xFilterModelMap[filterModel.name]!;
    // Important:
    final oldFilterInput = thisXFilterModel.filterInput;
    // Always set.
    thisXFilterModel.filterInput = filterInput;
    if (oldFilterInput != filterInput) {
      thisXFilterModel.queried = false;
    }
    if (forceReloadFilter) {
      thisXFilterModel._filterLoadHint = FilterLoadHint.force;
      thisXFilterModel.queried = false;
    }
    //
    if (srcBlockAndOptions != null) {
      final Block srcBlock = srcBlockAndOptions.block;
      final XBlock srcXBlock = xBlockMap[srcBlock.name]!;
      srcXBlock.setQueryHintToGreater(QryHint.force);
      srcXBlock.setOptions(
        queryType: srcBlockAndOptions.queryType,
        listUpdateStrategy: srcBlockAndOptions.listUpdateStrategy,
        suggestedSelection: srcBlockAndOptions.suggestedSelection,
        afterQueryDirective: srcBlockAndOptions.afterQueryDirective,
        pageable: srcBlockAndOptions.pageable,
      );
    }
    if (srcScalarAndOptions != null) {
      final Scalar srcScalar = srcScalarAndOptions.scalar;
      final XScalar srcXScalar = xScalarMap[srcScalar.name]!;
      srcXScalar.setQueryHintToGreater(QryHint.force);
      srcXScalar.setOptions(
        queryType: srcScalarAndOptions.queryType,
      );
    }
    //
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      final Block block = xBlock.block;
      QryHint queryHint = forceQueryAll ? QryHint.force : QryHint.none;
      bool isSrcBlock = false;
      if (srcBlockAndOptions != null) {
        final Block srcBlock = srcBlockAndOptions.block;

        if (srcBlock.isSameWith(block)) {
          isSrcBlock = true;
          queryHint = QryHint.force;
        }
        // Search: LOGIC-02.
        if (block.isAncestorOf(srcBlock)) {
          queryHint = QryHint.force;
        }
      }
      bool hasBlockContextX = block.ui.hasActiveUiComponentBlockRepresentative(
        alsoCheckChildren: true,
      );
      if (hasBlockContextX) {
        queryHint = QryHint.force;
      }
      //
      xBlock.setQueryHintToGreater(queryHint);
      if (!isSrcBlock) {
        // Set Default Options. They will be replaced if need.
        xBlock.setOptions(
          queryType: QueryType.realQuery,
          listUpdateStrategy: ListUpdateStrategy.replace,
          suggestedSelection: null,
          afterQueryDirective: null,
          pageable: null,
        );
      }
      if (queryHint == QryHint.force) {
        XBlock? parentXBlock = xBlock.parentXBlock;
        while (parentXBlock != null) {
          final Block parentBlock = parentXBlock.block;

          // Check if parent block has stale data or needs baseline initialization
          final bool isParentStaleOrPending = parentBlock.dataState.isPending ||
              parentBlock.dataState.isStale; // (***) Standardized Check

          // If this parent is directly along the ancestry chain of a forced target block,
          // we MUST force-query the parent first to guarantee data integrity,
          // regardless of whether the parent UI component is active or visible!
          if (isParentStaleOrPending) {
            parentXBlock.setQueryHintToGreater(QryHint.force);
          }

          parentXBlock = parentXBlock.parentXBlock;
        }
      }
    }
    //
    for (XScalar xScalar in thisXFilterModel.xScalars) {
      final Scalar scalar = xScalar.scalar;
      QryHint queryHint = forceQueryAll ? QryHint.force : QryHint.none;
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
      bool hasXActiveUI = scalar.ui.hasActiveUiComponent(
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
        while (parentXScalar != null) {
          final Scalar parentScalar = parentXScalar.scalar;

          // Check if parent block has stale data or needs baseline initialization
          final bool isParentStaleOrPending =
              parentScalar.dataState.isPending ||
                  parentScalar.dataState.isStale; // (***) Standardized Check

          // If this parent is directly along the ancestry chain of a forced target scalar,
          // we MUST force-query the parent first to guarantee data integrity,
          // regardless of whether the parent UI component is active or visible!
          if (isParentStaleOrPending) {
            parentXScalar.setQueryHintToGreater(QryHint.force);
          }
          parentXScalar = parentXScalar.parentXScalar;
        }
      }
    }
  }
}
