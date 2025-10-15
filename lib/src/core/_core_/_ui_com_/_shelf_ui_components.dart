part of '../core.dart';

class _ShelfUIComponents extends _UIComponents {
  final Shelf shelf;

  final Map<_RefreshableWidgetState, bool> __refreshableNeutralViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ShelfUIComponents({required this.shelf});

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    bool hasActive = _hasActiveBlockUIComponentCascade(shelf._rootBlocks);
    if (hasActive) {
      return true;
    }
    hasActive = _hasActiveScalarUIComponentCascade(shelf._rootScalars);
    return hasActive;
  }

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
    hasMounted = _hasMountedScalarUIComponentCascade(shelf._rootScalars);
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
      for (Scalar scalar in shelf._rootScalars) {
        __updateAllScalarUIComponentsCascade(scalar, withoutFilters: true);
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

  bool _hasMountedScalarUIComponentCascade(List<Scalar> scalars) {
    for (Scalar scalar in scalars) {
      if (scalar.ui.hasMountedUIComponent()) {
        return true;
      }
      bool hasMounted =
          _hasMountedScalarUIComponentCascade(scalar._childScalars);
      if (hasMounted) {
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

  bool _hasActiveBlockUIComponentCascade(List<Block> blocks) {
    for (Block block in blocks) {
      if (block.ui.hasActiveUIComponent(alsoCheckChildren: true)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveScalarUIComponentCascade(List<Scalar> scalars) {
    for (Scalar scalar in scalars) {
      if (scalar.ui.hasActiveUIComponent(alsoCheckChildren: true)) {
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

  void __updateAllScalarUIComponentsCascade(
    Scalar scalar, {
    required bool withoutFilters,
  }) {
    scalar.ui.updateAllUIComponents(withoutFilters: withoutFilters);
    //
    for (Scalar childScalar in scalar._childScalars) {
      __updateAllScalarUIComponentsCascade(
        childScalar,
        withoutFilters: withoutFilters,
      );
    }
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
    required List<Scalar> scalars,
    required bool withBlockFragment,
    required bool withScalarFragment,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withBlockControlBar,
    required bool withScalarControlBar,
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
        withSort: withSort,
        withForm: withForm,
        withBlockControlBar: withBlockControlBar,
        withControl: withControl,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        blocks: block.childBlocks,
        scalars: [],
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withScalarFragment: withScalarFragment,
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
    for (Scalar scalar in scalars) {
      Map<_RefreshableWidgetState, XState> m =
          scalar.ui._findMountedWidgetStates(
        activeOnly: activeOnly,
        withFilter: withFilter,
        withScalarControlBar: withScalarControlBar,
        withScalarFragment: withScalarFragment,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        scalars: scalar.childScalars,
        blocks: [],
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withScalarFragment: withScalarFragment,
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

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withScalarFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withBlockControlBar,
    required bool withScalarControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> founds = {};
    __findMountedWidgetStates(
      blocks: shelf._rootBlocks,
      scalars: shelf._rootScalars,
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withScalarFragment: withScalarFragment,
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
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withBlockFragment,
    required bool withScalarFragment,
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
      withBlockFragment: withBlockFragment,
      withScalarFragment: withScalarFragment,
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
