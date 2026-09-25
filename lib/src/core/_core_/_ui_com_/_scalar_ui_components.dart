part of '../core.dart';

/// Manages UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [Scalar].
///
/// This component coordinates reactive updates between UI widgets (e.g., Value Views,
/// Section Views, and Control Bars) and the Scalar runtime data state.
class _ScalarUiComponents extends _UiComponents {
  /// The owner scalar bound to this UI coordinator.
  final Scalar scalar;

  // Registered views: ScalarValueView, ScalarSectionView.
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};
  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUiComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered views and models.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ...__contentViewWidgetStates.keys,
      ...__controlBarWidgetStates.keys,
    ];
    return list
        .map((v) => v.faRoute)
        .nonNulls
        .toList()
        .toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any UI component connected to this scalar is currently mounted.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return __contentViewWidgetStates.isNotEmpty ||
        __controlBarWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any UI view connected to this scalar is actively visible on screen.
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
    // 1. Content View (ScalarValueView, ScalarSectionView)
    final String? componentName = findVisibleContentView(
      includeDescendants: false,
    );
    if (componentName != null) {
      return componentName;
    }

    // 2. ControlBar
    if (hasVisibleControlBar()) {
      return "ScalarControlBar";
    }

    // 3. Child Scalars
    if (includeDescendants) {
      for (final Scalar childScalar in scalar._childScalars) {
        final String? childComponentName = childScalar.ui.findVisibleView(
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

  /// Rebuilds active scalar control bars.
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

  /// Rebuilds all mounted primary content views (ScalarValueView, ScalarSectionView).
  // OLD: updateScalarBaseViews
  void refreshContentViews({bool force = true}) {
    for (final _ContextProviderViewState state
    in __contentViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted views connected to this scalar and its filter model.
  // OLD: updateAllUiComponents
  void refreshAllViews({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      scalar.filterModel?.ui.refreshAllViews();
    }
    refreshControlBars(force: force);
    refreshContentViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any content view (value view, section view) is actively visible on screen.
  // OLD: hasActiveScalarBaseView
  bool hasVisibleContentView({bool includeDescendants = false}) {
    final String? componentName = findVisibleContentView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  /// Locates the class name of the actively visible content view for diagnostics.
  // OLD: findActiveScalarBaseView
  String? findVisibleContentView({bool includeDescendants = false}) {
    return findVisibleContentViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  // OLD: findActiveScalarBaseViewWithContextKind
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = false,
  }) {
    for (final _ContextProviderViewState widgetState
    in __contentViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          __contentViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    if (includeDescendants) {
      for (final Scalar childScalar in scalar._childScalars) {
        final String? componentName =
        childScalar.ui.findVisibleContentViewWithContextKind(
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

  /// Checks whether an active [ScalarControlBar] is currently visible on screen.
  // OLD: hasActiveControlBar
  bool hasVisibleControlBar() {
    return hasVisibleControlBarWithContextKind(
      contextKind: null,
    );
  }

  /// Checks whether a [ScalarControlBar] matching [contextKind] is currently visible.
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

  /// Resolves the class name of the view currently demanding the Scalar data context.
  // OLD: findActiveUiComponentByScalarContext
  String? findVisibleScalarContextView({
    bool includeDescendants = false,
  }) {
    String? componentName = __findVisibleViewWithContextKind(
      contextKind: ContextKind.scalar,
      includeDescendants: includeDescendants,
    );
    if (componentName != null) {
      return componentName;
    }
    if (!includeDescendants) {
      return null;
    }
    for (final Scalar childScalar in scalar._childScalars) {
      componentName = childScalar.ui.__findVisibleViewWithContextKind(
        contextKind: ContextKind.scalar,
        includeDescendants: includeDescendants,
      );
      if (componentName != null) {
        return componentName;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether any active UI representation demands this Scalar's data context.
  // OLD: hasActiveUiComponentScalarRepresentative
  bool hasScalarContext({
    bool includeDescendants = false,
  }) {
    final String? componentName = findVisibleScalarContextView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = false,
  }) {
    //
    // Scalar Content Views:
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
      return "ScalarControlBar";
    }
    //
    if (includeDescendants) {
      for (final Scalar childScalar in scalar._childScalars) {
        final childComponentName =
        childScalar.ui.__findVisibleViewWithContextKind(
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

  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool scalarContextOld = hasScalarContext(
      includeDescendants: true,
    );
    __controlBarWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    final bool scalarContextCurrent = hasScalarContext(
      includeDescendants: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!scalarContextOld && scalarContextCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(scalar.shelf);
    } else if (scalarContextOld && !scalarContextCurrent) {
      scalar._broadcastScalarHidden();
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

  void _addScalarContentViewWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    final bool visibleOld =
        __contentViewWidgetStates[widgetState]?.isVisible ?? false;

    __contentViewWidgetStates.update(
      widgetState,
          (xState) => xState.._setShowing(isVisible),
      ifAbsent: () =>
      XState()
        .._setShowing(isVisible),
    );
    final bool visibleCurrent = hasVisibleViews();
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!visibleOld && visibleCurrent) {
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(scalar.shelf);
    } else if (visibleOld && !visibleCurrent) {
      scalar._broadcastScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeScalarContentViewWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    final bool visibleOld = hasVisibleViews();
    __contentViewWidgetStates.remove(widgetState);
    final bool visibleCurrent = hasVisibleViews();
    //
    if (visibleOld && !visibleCurrent) {
      scalar._broadcastScalarHidden();
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

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withScalarContentView,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui
            ._findMountedFilterPanelWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withScalarContentView) {
      ret.addAll(
        _findMountedContentViewWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withScalarControlBar) {
      ret.addAll(
        _findMountedControlBarWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withScalarContentView,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withScalarContentView: withScalarContentView,
      withFilter: withFilter,
      withScalarControlBar: withScalarControlBar,
      activeOnly: activeOnly,
    );
  }
}
