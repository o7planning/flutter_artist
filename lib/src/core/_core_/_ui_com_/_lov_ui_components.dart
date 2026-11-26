part of '../core.dart';

/// Manages UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [LovModel].
///
/// Serves as the runtime bridge between reactive LOV UI widgets (e.g., [LovView],
/// [LovViewBuilder], pagination bars) rendered inside a LOV dialog and the [LovModel]'s
/// execution engine.
class _LovUiComponents extends _UiComponents {
  /// The owner LOV model bound to this UI coordinator.
  final LovModel lovModel;

  // Registered views: LovView / LovViewBuilder.
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};
  final Map<_ContextProviderViewState, XState> __paginationWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _LovUiComponents({required this.lovModel});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered LOV views and models.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__paginationWidgetStates.keys,
    ];
    final Set<FaRouteData> faRoutes =
        list.map((v) => v.faRoute).nonNulls.toList().toSet();

    if (lovModel.filterModel != null) {
      faRoutes.addAll(lovModel.filterModel!.ui.faRouteDatas);
    }
    if (lovModel.clientSideSortModel != null) {
      faRoutes.addAll(lovModel.clientSideSortModel!.ui.faRouteDatas);
    }
    if (lovModel.serverSideSortModel != null) {
      faRoutes.addAll(lovModel.serverSideSortModel!.ui.faRouteDatas);
    }
    return faRoutes;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component connected to this LOV model is currently mounted.
  @override
  bool hasMountedViews() {
    return (lovModel.filterModel?.ui.hasMountedViews() ?? false) ||
        (lovModel.serverSideSortModel?.ui.hasMountedViews() ?? false) ||
        (lovModel.clientSideSortModel?.ui.hasMountedViews() ?? false) ||
        __contentViewWidgetStates.isNotEmpty ||
        __paginationWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether any active UI representation demands this LOV's items context.
  bool hasLovContext() {
    return findVisibleLovContextView() != null;
  }

  /// Checks if any UI view connected to this LOV model is actively visible on screen.
  bool hasVisibleViews() {
    return findVisibleView() != null;
  }

  /// Resolves the class name of any actively visible view for diagnostic inspection.
  String? findVisibleView() {
    return __findVisibleViewWithContextKind(contextKind: null);
  }

  /// Resolves the class name of the view currently demanding the LOV items context.
  String? findVisibleLovContextView() {
    return __findVisibleViewWithContextKind(contextKind: ContextKind.lovItems);
  }

  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    // 1. LOV Content Views (LovView, LovViewBuilder):
    final String? componentName = findVisibleContentViewWithContextKind(
      contextKind: contextKind,
    );
    if (componentName != null) {
      return componentName;
    }

    // 2. Pagination:
    if (hasVisiblePaginationWithContextKind(contextKind: contextKind)) {
      return "PaginationWidget";
    }

    // 3. Sort Panels (if any):
    if (lovModel.serverSideSortModel != null) {
      final bool has =
          lovModel.serverSideSortModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(lovModel.serverSideSortModel);
      }
    }
    if (lovModel.clientSideSortModel != null) {
      final bool has =
          lovModel.clientSideSortModel!.ui.hasVisibleViewsWithContextKind(
        contextKind: contextKind,
      );
      if (has) {
        return getClassNameWithoutGenerics(lovModel.clientSideSortModel);
      }
    }

    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any LOV content view is actively visible on screen.
  bool hasVisibleContentView() {
    return findVisibleContentView() != null;
  }

  /// Locates the class name of the actively visible LOV content view for diagnostics.
  String? findVisibleContentView() {
    return findVisibleContentViewWithContextKind(contextKind: null);
  }

  /// Locates the class name of the actively visible LOV content view filtered by [contextKind].
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
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
      if (widgetState.isContextKind(contextKind)) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether a pagination bar is currently visible on screen.
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
      if (widgetState.isContextKind(contextKind)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted primary content views ([LovView], [LovViewBuilder]).
  void refreshContentViews({bool force = true}) {
    for (final _ContextProviderViewState widgetState
        in __contentViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  /// Rebuilds active pagination controls bound to this LOV model.
  void refreshPaginationViews({bool force = false}) {
    for (final _ContextProviderViewState widgetState
        in __paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  /// Rebuilds all mounted views connected to this LOV model (filter, sort, content, pagination).
  void refreshAllViews({
    bool withoutFilters = false,
    bool force = true,
  }) {
    if (!withoutFilters) {
      lovModel.filterModel?.ui.refreshAllViews(force: force);
    }
    lovModel.serverSideSortModel?.ui.refreshAllViews(force: force);
    lovModel.clientSideSortModel?.ui.refreshAllViews(force: force);
    //
    refreshContentViews(force: force);
    refreshPaginationViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addLovContentViewWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool lovContextOld = hasLovContext();

    __contentViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    final bool lovContextCurrent = hasLovContext();

    if (isVisible) {
      FlutterArtist._addRecentModule(lovModel.shelf);
    }

    if (!lovContextOld && lovContextCurrent) {
      // TODO: Switch to a dedicated addLovModel(lovModel) queue entry if needed
      // to isolate LOV lazy-loading from background Shelf Blocks/Scalars.
      FlutterArtist.storage._lazyUiComponentTriggerQueue
          .addShelf(lovModel.shelf);
    }
  }

  void _removeLovContentViewWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __contentViewWidgetStates.remove(widgetState);
  }

  void _addPaginationWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    __paginationWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );

    if (isVisible) {
      FlutterArtist._addRecentModule(lovModel.shelf);
    }
  }

  void _removePaginationWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __paginationWidgetStates.remove(widgetState);
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

  Map<_ContextProviderViewState, XState> _findMountedPaginationWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __paginationWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withLovContentView,
    required bool withPagination,
    required bool withFilter,
    required bool withSort,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};

    if (withFilter && lovModel.filterModel != null) {
      ret.addAll(
        lovModel.filterModel!.ui._findMountedFilterPanelWidgetStates(
          activeOnly: activeOnly,
        ),
      );
    }

    if (withSort) {
      final SortModel? serverSortModel = lovModel.serverSideSortModel;
      if (serverSortModel != null) {
        ret.addAll(
          serverSortModel.ui._findMountedSortPanelWidgetStates(
            activeOnly: activeOnly,
          ),
        );
      }
      final SortModel? clientSortModel = lovModel.clientSideSortModel;
      if (clientSortModel != null) {
        ret.addAll(
          clientSortModel.ui._findMountedSortPanelWidgetStates(
            activeOnly: activeOnly,
          ),
        );
      }
    }

    if (withLovContentView) {
      ret.addAll(
        _findMountedContentViewWidgetStates(activeOnly: activeOnly),
      );
    }

    if (withPagination) {
      ret.addAll(
        _findMountedPaginationWidgetStates(activeOnly: activeOnly),
      );
    }

    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  Map<IContextProviderViewState, XState> _debugFindAllMountedWidgetStates() {
    return _debugFindMountedWidgetStates(
      withLovContentView: true,
      withPagination: true,
      withFilter: true,
      withSort: true,
      activeOnly: true,
    );
  }

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> _debugFindMountedWidgetStates({
    required bool withLovContentView,
    required bool withPagination,
    required bool withFilter,
    required bool withSort,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withLovContentView: withLovContentView,
      withPagination: withPagination,
      withFilter: withFilter,
      withSort: withSort,
      activeOnly: activeOnly,
    );
  }
}
