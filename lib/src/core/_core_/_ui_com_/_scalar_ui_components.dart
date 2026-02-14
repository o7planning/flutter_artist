part of '../core.dart';

class _ScalarUiComponents extends _UiComponents {
  final Scalar scalar;

  final Map<_RefreshableWidgetState, XState> __scalarBaseViewWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __scalarControlBarWidgetStates =
      {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUiComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return __scalarBaseViewWidgetStates.isNotEmpty ||
        __scalarControlBarWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent({bool alsoCheckChildren = false}) {
    String? componentName = findActiveUiComponent(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  String? findActiveUiComponent({bool alsoCheckChildren = false}) {
    bool active = false;
    // Filter
    // if (block.filterModel != null) {
    //   active = block.filterModel!.ui.hasActiveUiComponent();
    //   if (active) {
    //     return true;
    //   }
    // }
    // Scalar Base View:
    String? componentName = findActiveScalarBaseView(alsoCheckChildren: false);
    if (componentName != null) {
      return componentName;
    }
    // ControlBar:
    active = hasActiveControlBar();
    if (active) {
      return "ScalarControlBar";
    }
    //
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        componentName = childScalar.ui.findActiveUiComponent(
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
    required bool withScalarBaseView,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui._findMountedBaseViewWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withScalarBaseView) {
      ret.addAll(
        _findMountedBaseViewWidgetStates(activeOnly: activeOnly),
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

  void updateControlBars({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in __scalarControlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateScalarBaseViews({bool force = true}) {
    for (_RefreshableWidgetState state in __scalarBaseViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      scalar.filterModel?.ui.updateAllUiComponents();
    }
    updateControlBars(force: force);
    updateScalarBaseViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveScalarBaseView({required bool alsoCheckChildren}) {
    String? componentName = findActiveScalarBaseView(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  String? findActiveScalarBaseView({required bool alsoCheckChildren}) {
    return findActiveScalarBaseViewWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveScalarBaseViewWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    for (State widgetState in __scalarBaseViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          __scalarBaseViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      return getClassNameWithoutGenerics(widgetState.widget);
    }
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        String? componentName =
            childScalar.ui.findActiveScalarBaseViewWithRepresentativeType(
          representativeType: representativeType,
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
    return hasActiveControlBarWithRepresentativeType(
      representativeType: null,
    );
  }

  bool hasActiveControlBarWithRepresentativeType({
    required RepresentativeType? representativeType,
  }) {
    for (_RefreshableWidgetState widgetState
        in __scalarControlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          __scalarControlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isRepresentativeType(representativeType);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedBaseViewWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __scalarBaseViewWidgetStates,
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
    required bool isVisible,
  }) {
    bool activeOLD = hasActiveUiComponent();
    __scalarControlBarWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      // scalar.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(scalar.shelf);
    } else if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    __scalarControlBarWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addScalarBaseViewWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    bool activeOLD = hasActiveUiComponent();
    __scalarBaseViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(scalar.shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      // scalar.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(scalar.shelf);
    } else if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeScalarBaseViewWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    __scalarBaseViewWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
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
    required bool withScalarBaseView,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withScalarBaseView: withScalarBaseView,
      withFilter: withFilter,
      withScalarControlBar: withScalarControlBar,
      activeOnly: activeOnly,
    );
  }
}
