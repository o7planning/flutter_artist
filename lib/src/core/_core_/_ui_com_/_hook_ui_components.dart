part of '../core.dart';

class _HookUiComponents extends _UiComponents {
  final Hook hook;

  final Map<_RefreshableWidgetState, XState> __hookBaseViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _HookUiComponents({required this.hook});

  // ***************************************************************************
  // ***************************************************************************

  void updateHookBaseViews({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __hookBaseViewWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return __hookBaseViewWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponentHookRepresentative({
    bool alsoCheckChildren = false,
  }) {
    String? componentName = _findActiveUiComponentWithRepresentativeType(
      representativeType: RepresentativeType.hookRepresentative,
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

  String? findActiveUiComponentHookRepresentative({
    bool alsoCheckChildren = false,
  }) {
    return _findActiveUiComponentWithRepresentativeType(
      representativeType: RepresentativeType.hookRepresentative,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? _findActiveUiComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
    bool alsoCheckChildren = false,
  }) {
    bool has = false;
    //
    // Hook Base View:
    //
    String? componentName = findActiveHookBaseViewWithRepresentativeType(
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

  bool hasActiveHookBaseView({required bool alsoCheckChildren}) {
    String? componentName = findActiveHookBaseView(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveHookBaseView({required bool alsoCheckChildren}) {
    return findActiveHookBaseViewWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveHookBaseViewWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    var map = {...__hookBaseViewWidgetStates};
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
    updateHookBaseViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __hookBaseViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addHookBaseViewWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    bool hasXHookRepOLD = hasActiveUiComponentHookRepresentative(
      alsoCheckChildren: true,
    );
    __hookBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool hasXHookRepCURRENT = hasActiveUiComponentHookRepresentative(
      alsoCheckChildren: true,
    );
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(hook.shelf);
    }
    //
    if (!hasXHookRepOLD && hasXHookRepCURRENT) {
      // Fire event:
      // hook.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(hook.shelf);
    } else if (hasXHookRepOLD && !hasXHookRepCURRENT) {
      hook._emitHookHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeHookBaseViewWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    __hookBaseViewWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      hook._emitHookHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withHookBaseView,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withHookBaseView) {
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
    required bool withHookBaseView,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withHookBaseView: withHookBaseView,
      activeOnly: activeOnly,
    );
  }
}
