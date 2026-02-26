part of '../core.dart';

class _BlockUiComponents extends _UiComponents {
  final Block block;

  // Fragments: BlockItemsView - BlockItemDetailView - BlockSectionView.
  final Map<_RefreshableWidgetState, XState> __blockBaseViewWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __blockControlBarWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __controlWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __paginationWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _BlockUiComponents({required this.block});

  // ***************************************************************************
  // ***************************************************************************

  void updatePaginationViews({bool force = false}) {
    for (_RefreshableWidgetState widgetState in __paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateBlockBaseViews({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __blockBaseViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlBars({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __blockControlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlButtons({bool force = false}) {
    for (_RefreshableWidgetState widgetState in __controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return (block.filterModel?.ui.hasMountedUiComponent() ?? false) ||
        (block.serverSideSortModel?.ui.hasMountedUiComponent() ?? false) ||
        (block.clientSideSortModel?.ui.hasMountedUiComponent() ?? false) ||
        __blockBaseViewWidgetStates.isNotEmpty ||
        __blockControlBarWidgetStates.isNotEmpty ||
        __controlWidgetStates.isNotEmpty ||
        __paginationWidgetStates.isNotEmpty ||
        (block.formModel?.ui.hasMountedUiComponent() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponentBlockRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = findActiveUiComponentByBlockContext(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  bool hasActiveUiComponentFormRepresentative() {
    String? componentName = findActiveUiComponentByFormContext(
      alsoCheckChildren: false,
    );
    return componentName != null;
  }

  bool hasActiveUiComponentItemRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = findActiveUiComponentByItemContext(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  bool hasActiveUiComponent({bool alsoCheckChildren = false}) {
    String? componentName = findActiveUiComponent(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveUiComponent({bool alsoCheckChildren = false}) {
    return __activeUiComponentsWithContextKind(
      contextKind: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveUiComponentByBlockContext({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = __activeUiComponentsWithContextKind(
      contextKind: ContextKind.block,
      alsoCheckChildren: alsoCheckChildren,
    );
    if (componentName != null) {
      return componentName;
    }
    if (!alsoCheckChildren) {
      return null;
    }
    for (Block childBlock in block._childBlocks) {
      componentName = childBlock.ui.__activeUiComponentsWithContextKind(
        contextKind: ContextKind.item,
        alsoCheckChildren: alsoCheckChildren,
      );
      if (componentName != null) {
        return componentName;
      }
    }
    return null;
  }

  String? findActiveUiComponentByItemContext({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = __activeUiComponentsWithContextKind(
      contextKind: ContextKind.item,
      alsoCheckChildren: alsoCheckChildren,
    );
    if (componentName != null) {
      return componentName;
    }
    if (!alsoCheckChildren) {
      return null;
    }
    for (Block childBlock in block._childBlocks) {
      componentName = childBlock.ui.__activeUiComponentsWithContextKind(
        contextKind: ContextKind.block,
        alsoCheckChildren: alsoCheckChildren,
      );
      if (componentName != null) {
        return componentName;
      }
    }
    return null;
  }

  String? findActiveUiComponentByFormContext({
    bool alsoCheckChildren = false,
  }) {
    return __activeUiComponentsWithContextKind(
      contextKind: ContextKind.form,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? __activeUiComponentsWithContextKind({
    required ContextKind? contextKind,
    bool alsoCheckChildren = false,
  }) {
    bool has = false;
    //
    // Filter
    //
    // if (block.filterModel != null) {
    //   has = block.filterModel!.ui.hasActiveUiComponentWithContextKind(
    //     contextKind: contextKind,
    //   );
    //   if (has) {
    //     return getClassNameWithoutGenerics(block.filterModel);
    //   }
    // }
    //
    // Sort
    //
    if (block.serverSideSortModel != null) {
      has = block.serverSideSortModel!.ui.hasActiveUiComponentWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(block.serverSideSortModel);
      }
    }
    //
    if (block.clientSideSortModel != null) {
      has = block.clientSideSortModel!.ui.hasActiveUiComponentWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(block.clientSideSortModel);
      }
    }
    //
    // Form
    //
    if (block.formModel != null) {
      has = block.formModel!.ui.hasActiveUiComponentWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(block.formModel);
      }
    }
    //
    // Block Base Views:
    //
    String? componentName = findActiveBlockBaseViewWithContextKind(
      contextKind: contextKind,
      alsoCheckChildren: false,
    );
    if (componentName != null) {
      return componentName;
    }
    //
    // ControlBar:
    //
    has = hasActiveControlBarWithContextKind(
      contextKind: contextKind,
    );
    if (has) {
      return "BlockControlBar";
    }
    //
    // Control
    //
    has = hasActiveControlWidgetWithContextKind(
      contextKind: contextKind,
    );
    if (has) {
      return "ControlWidget";
    }
    //
    // Pagination
    //
    has = hasActivePaginationWithContextKind(
      contextKind: contextKind,
    );
    if (has) {
      return "PaginationWidget";
    }
    //
    if (alsoCheckChildren) {
      for (Block childBlock in block._childBlocks) {
        componentName = childBlock.ui.__activeUiComponentsWithContextKind(
          contextKind: contextKind,
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

  bool hasActiveBlockBaseView({required bool alsoCheckChildren}) {
    String? componentName = findActiveBlockBaseView(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveBlockBaseView({required bool alsoCheckChildren}) {
    return findActiveBlockBaseViewWithContextKind(
      contextKind: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveBlockBaseViewWithContextKind({
    required ContextKind? contextKind,
    required bool alsoCheckChildren,
  }) {
    var map = {...__blockBaseViewWidgetStates};
    for (_RefreshableWidgetState widgetState in map.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = map[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    if (alsoCheckChildren) {
      for (Block childBlock in block._childBlocks) {
        String? componentName =
            childBlock.ui.findActiveBlockBaseViewWithContextKind(
          contextKind: contextKind,
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
    return hasActiveControlBarWithContextKind(contextKind: null);
  }

  bool hasActiveControlBarWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (_RefreshableWidgetState widgetState
        in __blockControlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          __blockControlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlWidget() {
    return hasActiveControlWidgetWithContextKind(
      contextKind: null,
    );
  }

  bool hasActiveControlWidgetWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (_RefreshableWidgetState widgetState in __controlWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __controlWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActivePagination() {
    return hasActivePaginationWithContextKind(contextKind: null);
  }

  bool hasActivePaginationWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (_RefreshableWidgetState widgetState in __paginationWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __paginationWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      block.filterModel?.ui.updateAllUiComponents();
    }
    //
    block.serverSideSortModel?.ui.updateAllUiComponents(force: force);
    block.clientSideSortModel?.ui.updateAllUiComponents(force: force);
    //
    updateBlockBaseViews(force: force);
    updatePaginationViews(force: force);
    updateControlBars(force: force);
    updateControlButtons(force: force);
    //
    block.formModel?.ui.updateAllUiComponents(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateItemsView() {
    for (_RefreshableWidgetState widgetState
        in __blockBaseViewWidgetStates.keys) {
      if (widgetState.mounted &&
          widgetState.type == RefreshableWidgetType.blockItemsView) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __blockBaseViewWidgetStates,
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
    required bool isVisible,
  }) {
    __paginationWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    //
    if (isVisible) {
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
    required bool isVisible,
  }) {
    bool blockXBlockRepOLD = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    __blockControlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool blockXBlockRepCURRENT = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!blockXBlockRepOLD && blockXBlockRepCURRENT) {
      // Fire event:
      // block.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(block.shelf);
    } else if (blockXBlockRepOLD && !blockXBlockRepCURRENT) {
      block._emitBlockHidden();
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
    required bool isVisible,
  }) {
    bool blockXBlockRepOLD = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    __controlWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool blockXBlockRepCURRENT = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!blockXBlockRepOLD && blockXBlockRepCURRENT) {
      // Fire event:
      // block.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(block.shelf);
    } else if (blockXBlockRepOLD && !blockXBlockRepCURRENT) {
      block._emitBlockHidden();
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

  void _addBlockBaseViewWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    bool hasXBlockRepOLD = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    __blockBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool hasXBlockRepCURRENT = hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!hasXBlockRepOLD && hasXBlockRepCURRENT) {
      // Fire event:
      // block.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(block.shelf);
    } else if (hasXBlockRepOLD && !hasXBlockRepCURRENT) {
      block._emitBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeBlockBaseViewWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    __blockBaseViewWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      block._emitBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockBaseView,
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
        filterModel.ui._findMountedBaseViewWidgetStates(
          activeOnly: true,
        ),
      );
    }
    //
    if (withSort) {
      final SortModel? serverSortModel = block.serverSideSortModel;
      if (serverSortModel != null) {
        ret.addAll(
          serverSortModel.ui._findMountedBaseViewWidgetStates(
            activeOnly: true,
          ),
        );
      }
      //
      final SortModel? clientSortModel = block.clientSideSortModel;
      if (clientSortModel != null) {
        ret.addAll(
          clientSortModel.ui._findMountedBaseViewWidgetStates(
            activeOnly: true,
          ),
        );
      }
    }
    //
    if (withBlockBaseView) {
      ret.addAll(
        _findMountedBaseViewWidgetStates(activeOnly: activeOnly),
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
    required bool withBlockBaseView,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withControl,
    required bool withBlockControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withPagination: withPagination,
      withBlockBaseView: withBlockBaseView,
      withFilter: withFilter,
      withSort: withSort,
      withForm: withForm,
      withControl: withControl,
      withBlockControlBar: withBlockControlBar,
      activeOnly: activeOnly,
    );
  }
}
