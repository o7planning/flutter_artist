part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and hierarchical
/// view rebuild cascades across all data models contained within a [Shelf].
///
/// Functions as the top-level shelf coordinator orchestrating reactive updates downward
/// to root blocks, root scalars, and independent filter models.
class _ShelfUiComponents extends _UiComponents {
  /// The owner shelf bound to this UI coordinator.
  final Shelf shelf;

  // ***************************************************************************
  // ***************************************************************************

  _ShelfUiComponents({required this.shelf});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across all blocks, scalars, and filters in this shelf.
  @override
  Set<FaRouteData> get faRouteDatas {
    final Set<FaRouteData> set = {};
    for (final Block block in shelf.blocks) {
      set.addAll(block.ui.faRouteDatas);
    }
    for (final Scalar scalar in shelf.scalars) {
      set.addAll(scalar.ui.faRouteDatas);
    }
    for (final FilterModel filterModel in shelf._allFilterModels) {
      set.addAll(filterModel.ui.faRouteDatas);
    }
    return set;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component inside this shelf is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    final bool hasVisible = _hasVisibleBlockViewsCascade(shelf._rootBlocks);
    if (hasVisible) {
      return true;
    }
    return _hasVisibleScalarViewsCascade(shelf._rootScalars);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component inside this shelf is currently mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    final bool hasMounted = _hasMountedBlockViewsCascade(shelf._rootBlocks);
    if (hasMounted) {
      return true;
    }
    return _hasMountedScalarViewsCascade(shelf._rootScalars);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Cascades a rebuild request to all mounted views within this shelf (filters, scalars, and blocks).
  // OLD: updateAllUiComponents
  void refreshAllViews() {
    try {
      print("|----> ${getClassName(shelf)}.ui.refreshAllViews()");
      //
      for (final FilterModel filterModel in shelf._allFilterModels) {
        filterModel.ui.refreshAllViews();
      }
      //
      for (final Scalar scalar in shelf._rootScalars) {
        _refreshAllScalarViewsCascade(scalar, withoutFilters: true);
      }
      //
      for (final Block block in shelf._rootBlocks) {
        _refreshAllBlockViewsCascade(block, withoutFilters: true);
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _hasMountedScalarUiComponentCascade
  bool _hasMountedScalarViewsCascade(List<Scalar> scalars) {
    for (final Scalar scalar in scalars) {
      if (scalar.ui.hasMountedViews()) {
        return true;
      }
      final bool hasMounted =
      _hasMountedScalarViewsCascade(scalar._childScalars);
      if (hasMounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _hasMountedBlockUiComponentCascade
  bool _hasMountedBlockViewsCascade(List<Block> blocks) {
    for (final Block block in blocks) {
      if (block.ui.hasMountedViews()) {
        return true;
      }
      final bool hasMounted = _hasMountedBlockViewsCascade(block._childBlocks);
      if (hasMounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _hasActiveBlockUiComponentCascade
  bool _hasVisibleBlockViewsCascade(List<Block> blocks) {
    for (final Block block in blocks) {
      if (block.ui.hasVisibleViews(includeDescendants: true)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _hasActiveScalarUiComponentCascade
  bool _hasVisibleScalarViewsCascade(List<Scalar> scalars) {
    for (final Scalar scalar in scalars) {
      if (scalar.ui.hasVisibleViews(includeDescendants: true)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: __updateAllScalarUiComponentsCascade
  void _refreshAllScalarViewsCascade(Scalar scalar, {
    required bool withoutFilters,
  }) {
    scalar.ui.refreshAllViews(withoutFilters: withoutFilters);
    //
    for (final Scalar childScalar in scalar._childScalars) {
      _refreshAllScalarViewsCascade(
        childScalar,
        withoutFilters: withoutFilters,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: __updateAllBlockUiComponentsCascade
  void _refreshAllBlockViewsCascade(Block block, {
    required bool withoutFilters,
  }) {
    block.ui.refreshAllViews(withoutFilters: withoutFilters);
    //
    for (final Block childBlock in block._childBlocks) {
      _refreshAllBlockViewsCascade(
        childBlock,
        withoutFilters: withoutFilters,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __findMountedWidgetStates({
    required List<Block> blocks,
    required List<Scalar> scalars,
    required bool withBlockContentView,
    required bool withScalarContentView,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withBlockControlBar,
    required bool withScalarControlBar,
    required bool withControl,
    required bool activeOnly,
    required bool withPagination,
    required Map<_ContextProviderViewState, XState> founds,
  }) {
    for (final Block block in blocks) {
      final Map<_ContextProviderViewState, XState> m =
      block.ui._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockContentView: withBlockContentView,
        withFilter: withFilter,
        withSort: withSort,
        withForm: withForm,
        withBlockControlBar: withBlockControlBar,
        withControl: withControl,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        blocks: block.childBlocks,
        scalars: const [],
        withPagination: withPagination,
        withBlockContentView: withBlockContentView,
        withScalarContentView: withScalarContentView,
        withFilter: withFilter,
        withSort: withSort,
        withForm: withForm,
        withBlockControlBar: withBlockControlBar,
        withScalarControlBar: withScalarControlBar,
        withControl: withControl,
        activeOnly: activeOnly,
        founds: founds,
      );
    }
    for (final Scalar scalar in scalars) {
      final Map<_ContextProviderViewState, XState> m =
      scalar.ui._findMountedWidgetStates(
        activeOnly: activeOnly,
        withFilter: withFilter,
        withScalarControlBar: withScalarControlBar,
        withScalarContentView: withScalarContentView,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        scalars: scalar.childScalars,
        blocks: const [],
        withPagination: withPagination,
        withBlockContentView: withBlockContentView,
        withScalarContentView: withScalarContentView,
        withFilter: withFilter,
        withSort: withSort,
        withForm: withForm,
        withBlockControlBar: withBlockControlBar,
        withScalarControlBar: withScalarControlBar,
        withControl: withControl,
        activeOnly: activeOnly,
        founds: founds,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withBlockContentView,
    required bool withScalarContentView,
    required bool withPagination,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withBlockControlBar,
    required bool withScalarControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> founds = {};
    __findMountedWidgetStates(
      blocks: shelf._rootBlocks,
      scalars: shelf._rootScalars,
      withPagination: withPagination,
      withBlockContentView: withBlockContentView,
      withScalarContentView: withScalarContentView,
      withFilter: withFilter,
      withSort: withSort,
      withForm: withForm,
      withBlockControlBar: withBlockControlBar,
      withScalarControlBar: withScalarControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withBlockContentView,
    required bool withScalarContentView,
    required bool withPagination,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withBlockControlBar,
    required bool withScalarControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withBlockContentView: withBlockContentView,
      withScalarContentView: withScalarContentView,
      withPagination: withPagination,
      withFilter: withFilter,
      withSort: withSort,
      withForm: withForm,
      withBlockControlBar: withBlockControlBar,
      withScalarControlBar: withScalarControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
    );
  }
}
