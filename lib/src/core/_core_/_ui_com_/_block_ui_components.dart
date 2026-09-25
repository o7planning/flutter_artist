part of '../core.dart';

/// Manages UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [Block].
///
/// This component serves as the runtime bridge between reactive UI widgets (e.g., Table,
/// Detail View, Control Bar, Pagination) and the Block's execution engine.
class _BlockUiComponents extends _UiComponents {
  /// The owner block bound to this UI coordinator.
  final Block block;

  // Registered views: BlockItemsView, BlockItemDetailView, BlockSectionView.
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};
  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};
  final Map<_ContextProviderViewState, XState> __controlWidgetStates = {};
  final Map<_ContextProviderViewState, XState> __paginationWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _BlockUiComponents({required this.block});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered views and models.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__controlBarWidgetStates.keys,
      ...__controlWidgetStates.keys,
      ...__paginationWidgetStates.keys,
    ];
    final Set<FaRouteData> faRoutes =
    list
        .map((v) => v.faRoute)
        .nonNulls
        .toList()
        .toSet();
    if (block.formModel != null) {
      faRoutes.addAll(block.formModel!.ui.faRouteDatas);
    }
    if (block._clientSideSortModel != null) {
      faRoutes.addAll(block._clientSideSortModel!.ui.faRouteDatas);
    }
    if (block._serverSideSortModel != null) {
      faRoutes.addAll(block._serverSideSortModel!.ui.faRouteDatas);
    }
    return faRoutes;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds active pagination controls bound to this block.
  // OLD: updatePaginationViews
  void refreshPaginationViews({bool force = false}) {
    for (final _ContextProviderViewState widgetState
    in __paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted primary content views (ItemsView, DetailView, SectionView).
  // OLD: updateBlockBaseViews
  void refreshContentViews({bool force = false}) {
    for (final _ContextProviderViewState widgetState
    in __contentViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds active block control bars.
  // OLD: updateControlBars
  void refreshControlBars({bool force = false}) {
    for (final _ContextProviderViewState widgetState
    in __controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds standalone control buttons and auxiliary action controls.
  // OLD: updateControlButtons
  void refreshControlWidgets({bool force = false}) {
    for (final _ContextProviderViewState widgetState
    in __controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component connected to this block (or its models) is currently mounted.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return (block.filterModel?.ui.hasMountedViews() ?? false) ||
        (block.serverSideSortModel?.ui.hasMountedViews() ?? false) ||
        (block.clientSideSortModel?.ui.hasMountedViews() ?? false) ||
        __contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty ||
        __controlWidgetStates.isNotEmpty ||
        __paginationWidgetStates.isNotEmpty ||
        (block.formModel?.ui.hasMountedViews() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether any active UI representation demands the primary Block dataset context.
  // OLD: hasActiveUiComponentBlockRepresentative
  bool hasBlockContext({
    bool includeDescendants = false,
  }) {
    final String? componentName = findVisibleBlockContextView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Evaluates whether an active Form representation demands form-level dataset context.
  // OLD: hasActiveUiComponentFormRepresentative
  bool hasFormContext({
    bool includeDescendants = false,
  }) {
    final String? componentName = findVisibleFormContextView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Evaluates whether any active UI representation demands an active selected item context.
  // OLD: hasActiveUiComponentItemRepresentative
  bool hasItemContext({
    bool includeDescendants = false,
  }) {
    final String? componentName = findVisibleItemContextView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Checks if any UI view connected to this block is actively visible on the screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews({bool includeDescendants = false}) {
    final String? componentName = findVisibleView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  // OLD: findActiveUiComponent
  String? findVisibleView({bool includeDescendants = false}) {
    return __findVisibleViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  /// Resolves the class name of the view currently demanding the Block dataset context.
  // OLD: findActiveUiComponentByBlockContext
  String? findVisibleBlockContextView({
    bool includeDescendants = false,
  }) {
    String? componentName = __findVisibleViewWithContextKind(
      contextKind: ContextKind.block,
      includeDescendants: includeDescendants,
    );
    if (componentName != null) {
      return componentName;
    }
    if (!includeDescendants) {
      return null;
    }
    for (final Block childBlock in block._childBlocks) {
      componentName = childBlock.ui.__findVisibleViewWithContextKind(
        contextKind: ContextKind.item,
        includeDescendants: includeDescendants,
      );
      if (componentName != null) {
        return componentName;
      }
    }
    return null;
  }

  /// Resolves the class name of the view currently demanding an active item context.
  // OLD: findActiveUiComponentByItemContext
  String? findVisibleItemContextView({
    bool includeDescendants = false,
  }) {
    String? componentName = __findVisibleViewWithContextKind(
      contextKind: ContextKind.item,
      includeDescendants: includeDescendants,
    );
    if (componentName != null) {
      return componentName;
    }
    if (!includeDescendants) {
      return null;
    }
    for (final Block childBlock in block._childBlocks) {
      componentName = childBlock.ui.__findVisibleViewWithContextKind(
        contextKind: ContextKind.block,
        includeDescendants: includeDescendants,
      );
      if (componentName != null) {
        return componentName;
      }
    }
    return null;
  }

  /// Resolves the class name of the view currently demanding the Form data context.
  // OLD: findActiveUiComponentByFormContext
  String? findVisibleFormContextView({
    bool includeDescendants = false,
  }) {
    return __findVisibleViewWithContextKind(
      contextKind: ContextKind.form,
      includeDescendants: includeDescendants,
    );
  }

  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = false,
  }) {
    //
    // Sort
    //
    if (block.serverSideSortModel != null) {
      final bool has =
      block.serverSideSortModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(block.serverSideSortModel);
      }
    }
    //
    if (block.clientSideSortModel != null) {
      final bool has =
      block.clientSideSortModel!.ui.hasVisibleViewsWithContextKind(
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
      final bool has = block.formModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(block.formModel);
      }
    }
    //
    // Block Content Views:
    //
    final String? componentName = findVisibleContentViewWithContextKind(
      contextKind: contextKind,
      includeDescendants: false,
    );
    if (componentName != null) {
      return componentName;
    }
    //
    // ControlBar:
    //
    if (hasVisibleControlBarWithContextKind(contextKind: contextKind)) {
      return "BlockControlBar";
    }
    //
    // Control Widgets:
    //
    if (hasVisibleControlWidgetWithContextKind(contextKind: contextKind)) {
      return "ControlWidget";
    }
    //
    // Pagination:
    //
    if (hasVisiblePaginationWithContextKind(contextKind: contextKind)) {
      return "PaginationWidget";
    }
    //
    if (includeDescendants) {
      for (final Block childBlock in block._childBlocks) {
        final childComponentName =
        childBlock.ui.__findVisibleViewWithContextKind(
          contextKind: contextKind,
          includeDescendants: includeDescendants,
        );
        if (childComponentName != null) {
          return childComponentName;
        }
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any content view (table, list, detail, section) is actively visible on screen.
  // OLD: hasActiveBlockBaseView
  bool hasVisibleContentView({bool includeDescendants = false}) {
    final String? componentName = findVisibleContentView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Locates the class name of the actively visible content view for diagnostics.
  // OLD: findActiveBlockBaseView
  String? findVisibleContentView({bool includeDescendants = false}) {
    return findVisibleContentViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  // OLD: findActiveBlockBaseViewWithContextKind
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = false,
  }) {
    final map = {...__contentViewWidgetStates};
    for (final _ContextProviderViewState widgetState in map.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible = map[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    if (includeDescendants) {
      for (final Block childBlock in block._childBlocks) {
        final String? componentName =
        childBlock.ui.findVisibleContentViewWithContextKind(
          contextKind: contextKind,
          includeDescendants: true,
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

  /// Checks whether an active [BlockControlBar] is currently visible on screen.
  // OLD: hasActiveControlBar
  bool hasVisibleControlBar() {
    return hasVisibleControlBarWithContextKind(contextKind: null);
  }

  /// Checks whether a [BlockControlBar] matching [contextKind] is currently visible.
  bool hasVisibleControlBarWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
    in __controlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __controlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any standalone action control widget is currently visible.
  // OLD: hasActiveControlWidget
  bool hasVisibleControlWidget() {
    return hasVisibleControlWidgetWithContextKind(
      contextKind: null,
    );
  }

  /// Checks whether any standalone action control widget matching [contextKind] is visible.
  bool hasVisibleControlWidgetWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
    in __controlWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __controlWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether a pagination bar is currently visible on screen.
  // OLD: hasActivePagination
  bool hasVisiblePagination() {
    return hasVisiblePaginationWithContextKind(contextKind: null);
  }

  /// Checks whether a pagination bar matching [contextKind] is currently visible.
  bool hasVisiblePaginationWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
    in __paginationWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __paginationWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted views connected to this block and its child models.
  // OLD: updateAllUiComponents
  void refreshAllViews({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      block.filterModel?.ui.refreshAllViews();
    }
    //
    block.serverSideSortModel?.ui.refreshAllViews(force: force);
    block.clientSideSortModel?.ui.refreshAllViews(force: force);
    //
    refreshContentViews(force: force);
    refreshPaginationViews(force: force);
    refreshControlBars(force: force);
    refreshControlWidgets(force: force);
    //
    block.formModel?.ui.refreshAllViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds specifically the table or list item views.
  // OLD: updateItemsView
  void refreshItemsViewsOnly() {
    for (final _ContextProviderViewState widgetState
    in __contentViewWidgetStates.keys) {
      if (widgetState.mounted &&
          widgetState.type == ContextProviderViewType.blockItemsView) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedContentViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __contentViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_ContextProviderViewState, XState> _findMountedControlBarWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __controlBarWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_ContextProviderViewState, XState> _findMountedPaginationWidgetStates({
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
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    __paginationWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removePaginationWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __paginationWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool blockContextOld = hasBlockContext(
      includeDescendants: true,
    );
    __controlBarWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    final bool blockContextCurrent = hasBlockContext(
      includeDescendants: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!blockContextOld && blockContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(block.shelf);
    } else if (blockContextOld && !blockContextCurrent) {
      block._broadcastBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlBarWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __controlBarWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool blockContextOld = hasBlockContext(
      includeDescendants: true,
    );
    __controlWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    final bool blockContextCurrent = hasBlockContext(
      includeDescendants: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!blockContextOld && blockContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(block.shelf);
    } else if (blockContextOld && !blockContextCurrent) {
      block._broadcastBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __controlWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addBlockContentViewWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool blockContextOld = hasBlockContext(
      includeDescendants: true,
    );
    __contentViewWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    final bool blockContextCurrent = hasBlockContext(
      includeDescendants: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(block.shelf);
    }
    //
    if (!blockContextOld && blockContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(block.shelf);
    } else if (blockContextOld && !blockContextCurrent) {
      block._broadcastBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeBlockContentViewWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __contentViewWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();
    //
    if (visibleOld && !visibleCurrent) {
      block._broadcastBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockContentView,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withControl,
    required bool withBlockControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui._findMountedFilterPanelWidgetStates(
          activeOnly: activeOnly,
        ),
      );
    }
    //
    if (withSort) {
      final SortModel? serverSortModel = block.serverSideSortModel;
      if (serverSortModel != null) {
        ret.addAll(
          serverSortModel.ui._findMountedSortPanelWidgetStates(
            activeOnly: activeOnly,
          ),
        );
      }
      //
      final SortModel? clientSortModel = block.clientSideSortModel;
      if (clientSortModel != null) {
        ret.addAll(
          clientSortModel.ui._findMountedSortPanelWidgetStates(
            activeOnly: activeOnly,
          ),
        );
      }
    }
    //
    if (withBlockContentView) {
      ret.addAll(
        _findMountedContentViewWidgetStates(activeOnly: activeOnly),
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
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withPagination,
    required bool withBlockContentView,
    required bool withFilter,
    required bool withSort,
    required bool withForm,
    required bool withControl,
    required bool withBlockControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withPagination: withPagination,
      withBlockContentView: withBlockContentView,
      withFilter: withFilter,
      withSort: withSort,
      withForm: withForm,
      withControl: withControl,
      withBlockControlBar: withBlockControlBar,
      activeOnly: activeOnly,
    );
  }
}
