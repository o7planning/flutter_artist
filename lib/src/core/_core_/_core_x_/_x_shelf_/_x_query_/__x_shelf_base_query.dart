part of '../../../core.dart';

class _XShelfBaseQuery extends XShelf {
  _XShelfBaseQuery({
    required super.xShelfType,
    required super.shelf,
  });

  void _updateQueryStateFromFilterModelAndFilterInput({
    required TargetBlockAndOptions? targetBlockAndOptions,
    required TargetScalarAndOptions? targetScalarAndOptions,
    required FilterModel filterModel,
    required FilterInput? filterInput,
    required bool forceQueryAll,
    required bool forceReloadFilter,
  }) {
    assert(!forceQueryAll ||
        (targetBlockAndOptions == null && targetScalarAndOptions == null));

    if (filterModel.isDefaultFilterModel) {
      // Do Nothing.
    }

    final XFilterModel thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel._setFilterApplyPolicy(FilterApplyPolicy.instant);
    final oldFilterInput = thisXFilterModel.filterInput;
    thisXFilterModel.filterInput = filterInput;

    if (oldFilterInput != filterInput || forceReloadFilter) {
      thisXFilterModel._filterLoadHint = FilterLoadHint.force;
      thisXFilterModel.loadedInSession = false;
    }

    // Flag indicating whether the current operation is emptyQuery mode
    final bool isTargetEmptyQuery =
        targetBlockAndOptions?.queryType == QueryType.emptyQuery ||
            targetScalarAndOptions?.queryType == QueryType.emptyQuery;

    // -------------------------------------------------------------------------
    // 1. Explicitly configure target block and walk up its ancestry chain
    // -------------------------------------------------------------------------
    if (targetBlockAndOptions != null) {
      final Block targetBlock = targetBlockAndOptions.block;
      final XBlock targetXBlock = xBlockMap[targetBlock.name]!;
      targetXBlock.setQueryHintToGreater(QueryHint.force);
      targetXBlock.setOptions(
        queryType: targetBlockAndOptions.queryType,
        listUpdateStrategy: targetBlockAndOptions.listUpdateStrategy,
        suggestedSelection: targetBlockAndOptions.suggestedSelection,
        afterQueryDirective: targetBlockAndOptions.afterQueryDirective,
        pageable: targetBlockAndOptions.pageable,
      );

      // Immediately propagate force query to ancestors requiring baseline data
      XBlock? parentXBlock = targetXBlock.parentXBlock;
      while (parentXBlock != null) {
        final Block parentBlock = parentXBlock.block;
        final bool isParentNeedQuery = parentBlock.dataState.isNone ||
            parentBlock.dataState.isPending ||
            parentBlock.dataState.isStale;

        if (isParentNeedQuery) {
          parentXBlock.setQueryHintToGreater(QueryHint.force);
        }
        parentXBlock = parentXBlock.parentXBlock;
      }
    }

    // -------------------------------------------------------------------------
    // 2. Explicitly configure target scalar and walk up its ancestry chain
    // -------------------------------------------------------------------------
    if (targetScalarAndOptions != null) {
      final Scalar targetScalar = targetScalarAndOptions.scalar;
      final XScalar targetXScalar = xScalarMap[targetScalar.name]!;
      targetXScalar.setQueryHintToGreater(QueryHint.force);
      targetXScalar.setOptions(
        queryType: targetScalarAndOptions.queryType,
      );

      // Immediately propagate force query to parent scalars requiring baseline data
      XScalar? parentXScalar = targetXScalar.parentXScalar;
      while (parentXScalar != null) {
        final Scalar parentScalar = parentXScalar.scalar;
        final bool isParentNeedQuery = parentScalar.dataState.isNone ||
            parentScalar.dataState.isPending ||
            parentScalar.dataState.isStale;

        if (isParentNeedQuery) {
          parentXScalar.setQueryHintToGreater(QueryHint.force);
        }
        parentXScalar = parentXScalar.parentXScalar;
      }
    }

    // -------------------------------------------------------------------------
    // 3. Evaluate and update all Blocks bound to this FilterModel
    // -------------------------------------------------------------------------
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      final Block block = xBlock.block;

      final bool isTargetBlock = targetBlockAndOptions != null &&
          targetBlockAndOptions.block.name == block.name;

      if (isTargetBlock) {
        continue;
      }

      QueryHint queryHint = forceQueryAll ? QueryHint.force : QueryHint.none;

      if (targetBlockAndOptions != null) {
        final Block targetBlock = targetBlockAndOptions.block;
        if (block.isAncestorOf(targetBlock)) {
          queryHint = QueryHint.force;
        }
      }

      final bool hasBlockContextX = block.ui.hasBlockContext(
        includeDescendants: true,
      );
      if (hasBlockContextX && !isTargetEmptyQuery) {
        queryHint = QueryHint.force;
      }

      xBlock.setQueryHintToGreater(queryHint);

      xBlock.setOptions(
        queryType: QueryType.realQuery,
        listUpdateStrategy: ListUpdateStrategy.replace,
        suggestedSelection: null,
        afterQueryDirective: null,
        pageable: null,
      );

      if (queryHint == QueryHint.force) {
        XBlock? parentXBlock = xBlock.parentXBlock;
        while (parentXBlock != null) {
          final Block parentBlock = parentXBlock.block;
          final bool isParentNeedQuery = parentBlock.dataState.isNone ||
              parentBlock.dataState.isPending ||
              parentBlock.dataState.isStale;

          if (isParentNeedQuery) {
            parentXBlock.setQueryHintToGreater(QueryHint.force);
          }
          parentXBlock = parentXBlock.parentXBlock;
        }
      }
    }

    // -------------------------------------------------------------------------
    // 4. Evaluate and update all Scalars bound to this FilterModel
    // -------------------------------------------------------------------------
    for (XScalar xScalar in thisXFilterModel.xScalars) {
      final Scalar scalar = xScalar.scalar;

      final bool isTargetScalar = targetScalarAndOptions != null &&
          targetScalarAndOptions.scalar.name == scalar.name;

      if (isTargetScalar) {
        continue;
      }

      QueryHint queryHint = forceQueryAll ? QueryHint.force : QueryHint.none;

      if (targetScalarAndOptions != null) {
        final Scalar targetScalar = targetScalarAndOptions.scalar;
        if (scalar.isAncestorOf(targetScalar)) {
          queryHint = QueryHint.force;
        }
      }

      final bool hasXActiveUI = scalar.ui.hasVisibleViews(
        includeDescendants: true,
      );
      if (hasXActiveUI && !isTargetEmptyQuery) {
        queryHint = QueryHint.force;
      }

      xScalar.setQueryHintToGreater(queryHint);

      xScalar.setOptions(
        queryType: QueryType.realQuery,
      );

      if (queryHint == QueryHint.force) {
        XScalar? parentXScalar = xScalar.parentXScalar;
        while (parentXScalar != null) {
          final Scalar parentScalar = parentXScalar.scalar;
          final bool isParentNeedQuery = parentScalar.dataState.isNone ||
              parentScalar.dataState.isPending ||
              parentScalar.dataState.isStale;

          if (isParentNeedQuery) {
            parentXScalar.setQueryHintToGreater(QueryHint.force);
          }
          parentXScalar = parentXScalar.parentXScalar;
        }
      }
    }
  }
}
