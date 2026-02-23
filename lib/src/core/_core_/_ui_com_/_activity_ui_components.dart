part of '../core.dart';

class _ActivityUiComponents extends _UiComponents {
  final Activity activity;

  final Map<_RefreshableWidgetState, XState> __activityBaseViewWidgetStates =
      {};

  // ***************************************************************************
  // ***************************************************************************

  _ActivityUiComponents({required this.activity});

  // ***************************************************************************
  // ***************************************************************************

  void updateActivityBaseViews({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __activityBaseViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return __activityBaseViewWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponentActivityRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = _findActiveUiComponentWithRepresentativeType(
      representativeType: RepresentativeType.activityRepresentative,
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
    return _findActiveUiComponentWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveUiComponentActivityRepresentative({
    bool alsoCheckChildren = false,
  }) {
    return _findActiveUiComponentWithRepresentativeType(
      representativeType: RepresentativeType.activityRepresentative,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? _findActiveUiComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
    bool alsoCheckChildren = false,
  }) {
    bool has = false;
    //
    // Activity Base View:
    //
    String? componentName = findActiveActivityBaseViewWithRepresentativeType(
      representativeType: representativeType,
      alsoCheckChildren: false,
    );
    if (componentName != null) {
      return componentName;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveActivityBaseView({required bool alsoCheckChildren}) {
    String? componentName = findActiveActivityBaseView(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveActivityBaseView({required bool alsoCheckChildren}) {
    return findActiveActivityBaseViewWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveActivityBaseViewWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    var map = {...__activityBaseViewWidgetStates};
    for (_RefreshableWidgetState widgetState in map.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = map[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isRepresentativeType(representativeType);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents({
    bool force = true,
  }) {
    updateActivityBaseViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __activityBaseViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addActivityBaseViewWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    bool hasXActivityRepOLD = hasActiveUiComponentActivityRepresentative(
      alsoCheckChildren: true,
    );
    __activityBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool hasXActivityRepCURRENT = hasActiveUiComponentActivityRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentActivity(activity);
    }
    //
    if (!hasXActivityRepOLD && hasXActivityRepCURRENT) {
      // Fire event:
      // activity.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      // FlutterArtist.storage._naturalQueryQueue.addShelf(activity.shelf);
    } else if (hasXActivityRepOLD && !hasXActivityRepCURRENT) {
      activity._emitActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeActivityBaseViewWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    __activityBaseViewWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      activity._emitActivityHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withActivityBaseView,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withActivityBaseView) {
      ret.addAll(
        _findMountedBaseViewWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withActivityBaseView,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withActivityBaseView: withActivityBaseView,
      activeOnly: activeOnly,
    );
  }
}
