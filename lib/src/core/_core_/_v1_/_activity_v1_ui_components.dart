part of '../core.dart';

class _ActivityV1UiComponents extends _UiComponents {
  final ActivityV1 activity;

  final Map<_ContextProviderViewState, XState>
      __activityContentViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ActivityV1UiComponents({required this.activity});

  // ***************************************************************************
  // ***************************************************************************

  @override
  Set<FaRouteData> get faRouteDatas {
    return __activityContentViewWidgetStates.keys
        .map((v) => v.faRoute)
        .nonNulls
        .toList()
        .toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  void refreshActivityContentViews({bool force = false}) {
    for (_ContextProviderViewState widgetState
        in __activityContentViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedViews() {
    return __activityContentViewWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: hasActiveUiComponentActivityRepresentative
  bool hasActivityContext({
    bool includeDescendants = false,
  }) {
    String? componentName = _findVisibleViewWithContextKind(
      contextKind: ContextKind.activity,
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  // OLD: hasActiveUiComponent
  bool hasVisibleViews({bool includeDescendants = false}) {
    String? componentName = findVisibleView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  // OLD: findActiveUiComponent
  String? findVisibleView({bool includeDescendants = false}) {
    return _findVisibleViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  // findActiveUiComponentActivityRepresentative
  String? findVisibleActivityContextView({
    bool includeDescendants = false,
  }) {
    return _findVisibleViewWithContextKind(
      contextKind: ContextKind.activity,
      includeDescendants: includeDescendants,
    );
  }

  String? _findVisibleViewWithContextKind({
    required ContextKind? contextKind,
    bool includeDescendants = false,
  }) {
    bool has = false;
    //
    // Activity Base View:
    //
    String? componentName = findVisibleActivityContentViewWithContextKind(
      contextKind: contextKind,
      includeDescendants: false,
    );
    if (componentName != null) {
      return componentName;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveActivityBaseView({required bool includeDescendants}) {
    String? componentName = findActiveActivityBaseView(
      includeDescendants: includeDescendants,
    );
    return componentName != null;
  }

  String? findActiveActivityBaseView({required bool includeDescendants}) {
    return findVisibleActivityContentViewWithContextKind(
      contextKind: null,
      includeDescendants: includeDescendants,
    );
  }

  String? findVisibleActivityContentViewWithContextKind({
    required ContextKind? contextKind,
    required bool includeDescendants,
  }) {
    var map = {...__activityContentViewWidgetStates};
    for (_ContextProviderViewState widgetState in map.keys) {
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
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: updateAllUiComponents
  void refreshAllViews({
    bool force = true,
  }) {
    refreshActivityContentViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedContentViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __activityContentViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addActivityContentViewWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    bool hasXActivityRepOLD = hasActivityContext(
      includeDescendants: true,
    );
    __activityContentViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool hasXActivityRepCURRENT = hasActivityContext(
      includeDescendants: true,
    );
    //
    if (isVisible) {
      // FlutterArtist.desk._addRecentActivity(activity);
    }
    //
    if (!hasXActivityRepOLD && hasXActivityRepCURRENT) {
      // Fire event:
      // activity.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      // FlutterArtist.storage._naturalQueryQueue.addShelf(activity.shelf);
    } else if (hasXActivityRepOLD && !hasXActivityRepCURRENT) {
      activity._broadcastActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeActivityContentViewWidgetState({required State widgetState}) {
    bool activeOLD = hasVisibleViews();
    __activityContentViewWidgetStates.remove(widgetState);
    bool activeCURRENT = hasVisibleViews();
    //
    if (activeOLD && !activeCURRENT) {
      activity._broadcastActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedWidgetStates({
    required bool withActivityBaseView,
    required bool activeOnly,
  }) {
    Map<_ContextProviderViewState, XState> ret = {};
    //
    if (withActivityBaseView) {
      ret.addAll(
        _findMountedContentViewWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IContextProviderViewState, XState> debugFindMountedWidgetStates({
    required bool withActivityBaseView,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withActivityBaseView: withActivityBaseView,
      activeOnly: activeOnly,
    );
  }
}
