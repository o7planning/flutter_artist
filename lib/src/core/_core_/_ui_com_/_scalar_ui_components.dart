part of '../core.dart';

class _ScalarUIComponents extends _UIComponents {
  final Scalar scalar;

  final Map<_RefreshableWidgetState, XState> __scalarFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __scalarControlBarWidgetStates =
      {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUIComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return __scalarFragmentWidgetStates.isNotEmpty ||
        __scalarControlBarWidgetStates.isNotEmpty;
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
    // Scalar Fragment:
    String? componentName = findActiveScalarFragment(alsoCheckChildren: false);
    if (componentName != null) {
      return componentName;
    }
    // ControlBar:
    active = hasActiveControlBarWidget();
    if (active) {
      return "ScalarControlBar";
    }
    //
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        componentName = childScalar.ui.findActiveUIComponent(
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

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withScalarFragment,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui._findMountedFragmentWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withScalarFragment) {
      ret.addAll(
        _findMountedFragmentWidgetStates(activeOnly: activeOnly),
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

  void updateControlBarWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __scalarControlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateFragmentWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in __scalarFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      scalar.filterModel?.ui.updateAllUIComponents();
    }
    updateControlBarWidgets(force: force);
    updateFragmentWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveScalarFragment({required bool alsoCheckChildren}) {
    String? componentName = findActiveScalarFragment(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveScalarFragment({required bool alsoCheckChildren}) {
    for (State widgetState in __scalarFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing =
            __scalarFragmentWidgetStates[widgetState]?.isShowing ?? false;
        if (isShowing) {
          return getClassNameWithoutGenerics(widgetState.widget);
        }
      }
    }
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        String? componentName = childScalar.ui.findActiveScalarFragment(
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

  bool hasActiveControlBarWidget() {
    for (State widgetState in __scalarControlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing =
            __scalarControlBarWidgetStates[widgetState]?.isShowing ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedFragmentWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __scalarFragmentWidgetStates,
      activeOnly: activeOnly,
    );
  }

  Map<_RefreshableWidgetState, XState> _findMountedControlBarWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __scalarControlBarWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __scalarControlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      scalar.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __scalarControlBarWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addScalarFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __scalarFragmentWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isShowing),
      ifAbsent: () => XState().._setShowing(isShowing),
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      scalar.shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeScalarFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __scalarFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withPagination,
    required bool withScalarFragment,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withScalarFragment: withScalarFragment,
      withFilter: withFilter,
      withScalarControlBar: withScalarControlBar,
      activeOnly: activeOnly,
    );
  }
}
