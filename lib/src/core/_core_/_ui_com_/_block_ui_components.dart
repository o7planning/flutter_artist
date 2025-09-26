part of '../core.dart';

class _BlockUIComponents extends _UIComponents {
  final Block block;

  final Map<_RefreshableWidgetState, XState> __blockFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __controlBarWidgetStates = {};
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
    for (_RefreshableWidgetState widgetState in __controlBarWidgetStates.keys) {
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
        __blockFragmentWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty ||
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
        in __controlBarWidgetStates.keys) {
      bool visible =
          __controlBarWidgetStates[controlBarState]?.isShowing ?? false;
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
    __controlBarWidgetStates.update(
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
    __controlBarWidgetStates.remove(widgetState);
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
    required bool withForm,
    required bool withControl,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withFilter) {
      ret.addAll(
          block._registeredOrDefaultFilterModel.ui._filterFragmentWidgetStates);
    }
    //
    if (withBlockFragment) {
      ret.addAll(__blockFragmentWidgetStates);
    }
    //
    if (withPagination) {
      ret.addAll(__paginationWidgetStates);
    }
    //
    if (withControlBar) {
      ret.addAll(__controlBarWidgetStates);
    }
    if (withControl) {
      ret.addAll(__controlWidgetStates);
    }
    //
    if (withForm && block.formModel != null) {
      ret.addAll(block.formModel!.ui._formWidgetStates);
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
    required bool withForm,
    required bool withControl,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControl: withControl,
      withControlBar: withControlBar,
      activeOnly: activeOnly,
    );
  }
}
