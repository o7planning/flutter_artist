part of '../core.dart';

class _ShelfUIComponents {
  final Shelf shelf;

  final Map<_RefreshableWidgetState, bool> _refreshableNeutralViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ShelfUIComponents({required this.shelf});

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    bool hasMounted = _refreshableNeutralViewStates.isNotEmpty;
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
    _refreshableNeutralViewStates[widgetState] = isShowing;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    _refreshableNeutralViewStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllRefreshableNeutralViews() {
    __updateRefreshableNeutralViews(force: true);
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
    for (_RefreshableWidgetState state in _refreshableNeutralViewStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }
}
