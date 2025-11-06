part of '../core.dart';

class _ScalarUIComponents extends _UIComponents {
  final Scalar scalar;

  final Map<_RefreshableWidgetState, XState> __scalarPieceWidgetStates = {};
  final Map<_RefreshableWidgetState, XState> __scalarControlBarWidgetStates =
      {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUIComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return __scalarPieceWidgetStates.isNotEmpty ||
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
    // Scalar Piece:
    String? componentName = findActiveScalarPiece(alsoCheckChildren: false);
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
    required bool withScalarPiece,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> ret = {};
    //
    if (withFilter) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      ret.addAll(
        filterModel.ui._findMountedPieceWidgetStates(activeOnly: activeOnly),
      );
    }
    //
    if (withScalarPiece) {
      ret.addAll(
        _findMountedPieceWidgetStates(activeOnly: activeOnly),
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

  void updatePieceWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in __scalarPieceWidgetStates.keys) {
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
    updatePieceWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveScalarPiece({required bool alsoCheckChildren}) {
    String? componentName = findActiveScalarPiece(
      alsoCheckChildren: alsoCheckChildren,
    );
    return componentName != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  String? findActiveScalarPiece({required bool alsoCheckChildren}) {
    return findActiveScalarPieceWithRepresentativeType(
      representativeType: null,
      alsoCheckChildren: alsoCheckChildren,
    );
  }

  String? findActiveScalarPieceWithRepresentativeType({
    required RepresentativeType? representativeType,
    required bool alsoCheckChildren,
  }) {
    for (State widgetState in __scalarPieceWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __scalarPieceWidgetStates[widgetState]?.isShowing ?? false;
      if (!visible) {
        continue;
      }
      return getClassNameWithoutGenerics(widgetState.widget);
    }
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        String? componentName =
            childScalar.ui.findActiveScalarPieceWithRepresentativeType(
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

  bool hasActiveControlBarWidget() {
    return hasActiveControlBarWidgetWithRepresentativeType(
      representativeType: null,
    );
  }

  bool hasActiveControlBarWidgetWithRepresentativeType({
    required RepresentativeType? representativeType,
  }) {
    for (_RefreshableWidgetState widgetState
        in __scalarControlBarWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          __scalarControlBarWidgetStates[widgetState]?.isShowing ?? false;
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

  Map<_RefreshableWidgetState, XState> _findMountedPieceWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __scalarPieceWidgetStates,
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

  void _addScalarPieceWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __scalarPieceWidgetStates.update(
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

  void _removeScalarPieceWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    __scalarPieceWidgetStates.remove(widgetState);
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
    required bool withScalarPiece,
    required bool withFilter,
    required bool withScalarControlBar,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withScalarPiece: withScalarPiece,
      withFilter: withFilter,
      withScalarControlBar: withScalarControlBar,
      activeOnly: activeOnly,
    );
  }
}
