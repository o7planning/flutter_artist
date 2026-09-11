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
    // TODO: Hardcode?
    thisXFilterModel._setFilterApplyPolicy(FilterApplyPolicy.instant);
    final oldFilterInput = thisXFilterModel.filterInput;
    thisXFilterModel.filterInput = filterInput;

    if (oldFilterInput != filterInput) {
      // Test Case: [20c].
      thisXFilterModel._filterLoadHint = FilterLoadHint.force;
      thisXFilterModel.loadedInSession = false;
    }
    if (forceReloadFilter) {
      thisXFilterModel._filterLoadHint = FilterLoadHint.force;
      thisXFilterModel.loadedInSession = false;
    }

    // Flag indicating whether the current operation is emptyQuery mode
    final bool isTargetEmptyQuery =
        targetBlockAndOptions?.queryType == QueryType.emptyQuery;

    // 1. Explicitly configure target block if provided
    if (targetBlockAndOptions != null) {
      final Block targetBlock = targetBlockAndOptions.block;
      final XBlock targetXBlock = xBlockMap[targetBlock.name]!;
      targetXBlock.setQueryHintToGreater(QryHint.force);
      targetXBlock.setOptions(
        queryType: targetBlockAndOptions.queryType,
        listUpdateStrategy: targetBlockAndOptions.listUpdateStrategy,
        suggestedSelection: targetBlockAndOptions.suggestedSelection,
        afterQueryDirective: targetBlockAndOptions.afterQueryDirective,
        pageable: targetBlockAndOptions.pageable,
      );
    }

    // 2. Explicitly configure target scalar if provided
    if (targetScalarAndOptions != null) {
      final Scalar targetScalar = targetScalarAndOptions.scalar;
      final XScalar targetXScalar = xScalarMap[targetScalar.name]!;
      targetXScalar.setQueryHintToGreater(QryHint.force);
      targetXScalar.setOptions(
        queryType: targetScalarAndOptions.queryType,
      );
    }

    // -------------------------------------------------------------------------
    // 3. Evaluate and update all Blocks bound to this FilterModel
    // -------------------------------------------------------------------------
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      final Block block = xBlock.block;

      // Safe identity check using unique name to avoid proxy / type mismatch
      final bool isSrcBlock = targetBlockAndOptions != null &&
          targetBlockAndOptions.block.name == block.name;

      if (isSrcBlock) {
        // Target block already fully configured above; do NOT override its options or queryType!
        continue;
      }

      QryHint queryHint = forceQueryAll ? QryHint.force : QryHint.none;

      if (targetBlockAndOptions != null) {
        final Block targetBlock = targetBlockAndOptions.block;
        // Search: LOGIC-02: Ancestors of the target block must be evaluated
        if (block.isAncestorOf(targetBlock)) {
          queryHint = QryHint.force;
        }
      }

      // If emptyQuery is requested, do not automatically force-query sibling or child UI blocks!
      final bool hasBlockContextX =
          block.ui.hasActiveUiComponentBlockRepresentative(
        alsoCheckChildren: true,
      );
      if (hasBlockContextX && !isTargetEmptyQuery) {
        queryHint = QryHint.force;
      }

      xBlock.setQueryHintToGreater(queryHint);

      // Reset default options for non-target blocks
      xBlock.setOptions(
        queryType: QueryType.realQuery,
        listUpdateStrategy: ListUpdateStrategy.replace,
        suggestedSelection: null,
        afterQueryDirective: null,
        pageable: null,
      );

      if (queryHint == QryHint.force) {
        XBlock? parentXBlock = xBlock.parentXBlock;
        while (parentXBlock != null) {
          final Block parentBlock = parentXBlock.block;

          // Check if parent block has stale data or needs baseline initialization
          final bool isParentStaleOrPending =
              parentBlock.dataState.isPending || parentBlock.dataState.isStale;

          // Force query parent first if it is on the ancestry path and not yet fresh
          if (isParentStaleOrPending) {
            parentXBlock.setQueryHintToGreater(QryHint.force);
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

      final bool isSrcScalar = targetScalarAndOptions != null &&
          targetScalarAndOptions.scalar.name == scalar.name;

      if (isSrcScalar) {
        // Target scalar already configured above; do NOT override its options!
        continue;
      }

      QryHint queryHint = forceQueryAll ? QryHint.force : QryHint.none;

      if (targetScalarAndOptions != null) {
        final Scalar targetScalar = targetScalarAndOptions.scalar;
        // Search: LOGIC-02: Ancestors of the target scalar must be evaluated
        if (scalar.isAncestorOf(targetScalar)) {
          queryHint = QryHint.force;
        }
      }

      final bool hasXActiveUI = scalar.ui.hasActiveUiComponent(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI && !isTargetEmptyQuery) {
        queryHint = QryHint.force;
      }

      xScalar.setQueryHintToGreater(queryHint);

      // Reset default options for non-target scalars
      xScalar.setOptions(
        queryType: QueryType.realQuery,
      );

      if (queryHint == QryHint.force) {
        XScalar? parentXScalar = xScalar.parentXScalar;
        while (parentXScalar != null) {
          final Scalar parentScalar = parentXScalar.scalar;

          // Check if parent scalar has stale data or needs baseline initialization
          final bool isParentStaleOrPending =
              parentScalar.dataState.isPending ||
                  parentScalar.dataState.isStale;

          if (isParentStaleOrPending) {
            parentXScalar.setQueryHintToGreater(QryHint.force);
          }

          parentXScalar = parentXScalar.parentXScalar;
        }
      }
    }
  }
}
