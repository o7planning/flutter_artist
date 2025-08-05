part of '../core.dart';

class _ShelfUIComponents extends _UIComponents {
  final Shelf shelf;

  final Map<_RefreshableWidgetState, bool> __refreshableNeutralViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ShelfUIComponents({required this.shelf});

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    bool hasMounted = __refreshableNeutralViewStates.isNotEmpty;
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedBlockUIComponentCascade(shelf._rootBlocks);
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedScalarUIComponent();
    if (hasMounted) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents() {
    try {
      print("|----> ${getClassName(shelf)}.ui.updateAllUIComponents()");
      __updateRefreshableNeutralViews();
      //
      for (FilterModel filterModel in shelf._allFilterModels) {
        filterModel.ui.updateAllUIComponents();
      }
      //
      for (Scalar scalar in shelf._scalars) {
        scalar.ui.updateAllUIComponents(withoutFilters: true);
      }
      //
      for (Block block in shelf._rootBlocks) {
        __updateAllBlockUIComponentsCascade(block, withoutFilters: true);
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllRefreshableNeutralViews() {
    __updateRefreshableNeutralViews(force: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasMountedScalarUIComponent() {
    for (Scalar scalar in shelf.scalars) {
      if (scalar.ui.hasMountedUIComponent()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasMountedBlockUIComponentCascade(List<Block> blocks) {
    for (Block block in blocks) {
      if (block.ui.hasMountedUIComponent()) {
        return true;
      }
      bool hasMounted = _hasMountedBlockUIComponentCascade(block._childBlocks);
      if (hasMounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _addShelfWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    __refreshableNeutralViewStates[widgetState] = isShowing;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    __refreshableNeutralViewStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateAllBlockUIComponentsCascade(
    Block block, {
    required bool withoutFilters,
  }) {
    block.ui.updateAllUIComponents(withoutFilters: withoutFilters);
    //
    for (Block childBlock in block._childBlocks) {
      __updateAllBlockUIComponentsCascade(
        childBlock,
        withoutFilters: withoutFilters,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateRefreshableNeutralViews({bool force = true}) {
    for (_RefreshableWidgetState state in __refreshableNeutralViewStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __findMountedWidgetStates({
    required List<Block> blocks,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
    required bool withPagination,
    required Map<_RefreshableWidgetState, XState> founds,
  }) {
    for (Block block in blocks) {
      Map<_RefreshableWidgetState, XState> m =
          block.ui._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
        activeOnly: activeOnly,
        blocks: block.childBlocks,
        founds: founds,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
      blocks: shelf._rootBlocks,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withBlockFragment: withBlockFragment,
      withPagination: withPagination,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
    );
  }
}
