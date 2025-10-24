part of '../core.dart';

class _BlockUIComponents extends _UIComponents {
  final Block block;

  final Map<_RefreshableWidgetState, XState> __blockFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __blockControlBarWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __controlWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __paginationWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _BlockUIComponents({required this.block});

  // ***************************************************************************
  // ***************************************************************************

  void updatePaginationWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in __paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateBlockFragmentWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlBarWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __blockControlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in __controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return (block.filterModel?.ui.hasMountedUIComponent() ?? false) ||
        (block.serverSideSortModel?.ui.hasMountedUIComponent() ?? false) ||
        (block.clientSideSortModel?.ui.hasMountedUIComponent() ?? false) ||
        __blockFragmentWidgetStates.isNotEmpty ||
        __blockControlBarWidgetStates.isNotEmpty ||
        __controlWidgetStates.isNotEmpty ||
        __paginationWidgetStates.isNotEmpty ||
        (block.formModel?.ui.hasMountedUIComponent() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent({bool alsoCheckChildren = false}) {
    String? componentName = findActiveUIComponent(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveUIComponent({bool alsoCheckChildren = false}) {
    bool active = false;
    // Filter
    // if (block.filterModel != null) {
    //   active = block.filterModel!.ui.hasActiveUIComponent();
    //   if (active) {
    //     return true;
    //   }
    // }
    // Sort
    if (block.serverSideSortModel != null) {
      active = block.serverSideSortModel!.ui.hasActiveUIComponent();
      if (active) {
        return getClassNameWithoutGenerics(block.serverSideSortModel);
      }
    }
    if (block.clientSideSortModel != null) {
      active = block.clientSideSortModel!.ui.hasActiveUIComponent();
      if (active) {
        return getClassNameWithoutGenerics(block.clientSideSortModel);
      }
    }
    // Form
    active =
        block.formModel != null && block.formModel!.ui.hasActiveUIComponent();
    if (active) {
      return getClassNameWithoutGenerics(block.formModel);
    }
    // Block Fragment:
    String? componentName = findActiveBlockFragment(alsoCheckChildren: false);
    if (componentName != null) {
      return componentName;
    }
    // ControlBar:
    active = hasActiveControlBar();
    if (active) {
      return "BlockControlBar";
    }
    // Control
    active = hasActiveControlWidget();
    if (active) {
      return "ControlWidget";
    }
    // Pagination
    active = hasActivePaginationWidget();
    if (active) {
      return "PaginationWidget";
    }
    //
    if (alsoCheckChildren) {
      for (Block childBlock in block._childBlocks) {
        componentName = childBlock.ui.findActiveUIComponent(
          alsoCheckChildren: alsoCheckChildren,
        );
        if (componentName != null) {
          return componentName;
        }
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveBlockFragment({required bool alsoCheckChildren}) {
    String? componentName = findActiveBlockFragment(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveBlockFragment({required bool alsoCheckChildren}) {
    var map = {...__blockFragmentWidgetStates};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState]?.isShowing ?? false;
        if (isShowing) {
          return getClassNameWithoutGenerics(widgetState.widget);
        }
      }
    }
    if (alsoCheckChildren) {
      for (Block childBlock in block._childBlocks) {
        String? componentName = childBlock.ui.findActiveBlockFragment(
          alsoCheckChildren: true,
        );
        if (componentName != null) {
          return componentName;
        }
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlBar() {
    for (_RefreshableWidgetState controlBarState
        in __blockControlBarWidgetStates.keys) {
      bool visible =
          __blockControlBarWidgetStates[controlBarState]?.isShowing ?? false;
      if (visible && controlBarState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlWidget() {
    for (_RefreshableWidgetState controlState in __controlWidgetStates.keys) {
      bool visible = __controlWidgetStates[controlState]?.isShowing ?? false;
      if (visible && controlState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActivePaginationWidget() {
    for (_RefreshableWidgetState paginationState
        in __paginationWidgetStates.keys) {
      bool visible =
          __paginationWidgetStates[paginationState]?.isShowing ?? false;
      if (visible && paginationState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      block.filterModel?.ui.updateAllUIComponents();
    }
    //
    block.serverSideSortModel?.ui.updateAllUIComponents(force: force);
    block.clientSideSortModel?.ui.updateAllUIComponents(force: force);
    //
    updateBlockFragmentWidgets(force: force);
    updatePaginationWidgets(force: force);
    updateControlBarWidgets(force: force);
    updateControlWidgets(force: force);
    //
    block.formModel?.ui.updateAllUIComponents(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateItemsView() {
    // TODO: Sua lai cho nay.
    for (_RefreshableWidgetState widgetState
        in __blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedFragmentWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __blockFragmentWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_RefreshableWidgetState, XState> _findMountedControlBarWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __blockControlBarWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_RefreshableWidgetState, XState> _findMountedPaginationWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __paginationWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addPaginationWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    __paginationWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removePaginationWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    __paginationWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __blockControlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      block.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    __blockControlBarWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __controlWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      block.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    __controlWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addBlockFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __blockFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      block.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeBlockFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __blockFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withControl,
    required bool withBlockControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui._findMountedFragmentWidgetStates(
          activeOnly: true,
        ),
      );
    }
    //
    if (withSort) {
      final SortModel? serverSortModel = block.serverSideSortModel;
      if (serverSortModel != null) {
        ret.addAll(
          serverSortModel.ui._findMountedFragmentWidgetStates(
            activeOnly: true,
          ),
        );
      }
      //
      final SortModel? clientSortModel = block.clientSideSortModel;
      if (clientSortModel != null) {
        ret.addAll(
          clientSortModel.ui._findMountedFragmentWidgetStates(
            activeOnly: true,
          ),
        );
      }
    }
    //
    if (withBlockFragment) {
      ret.addAll(
        _findMountedFragmentWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withPagination) {
      ret.addAll(
        _findMountedPaginationWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withBlockControlBar) {
      ret.addAll(
        _findMountedControlBarWidgetStates(activeOnly: activeOnly),
      );
    }
    // if (withControl) {
    //   ret.addAll(__controlWidgetStates);
    // }
    //
    if (withForm && block.formModel != null) {
      ret.addAll(
        block.formModel!.ui._findMountedFormWidgetStates(
          activeOnly: activeOnly,
        ),
      );
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withControl,
    required bool withBlockControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withSort: withSort,
      withForm: withForm,
      withControl: withControl,
      withBlockControlBar: withBlockControlBar,
      activeOnly: activeOnly,
    );
  }
}
