part of '../core.dart';

class _ScalarUIComponents extends _UIComponents {
  final Scalar scalar;

  final Map<_RefreshableWidgetState, bool> __scalarFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> __scalarControlWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUIComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUIComponent() {
    return __scalarFragmentWidgetStates.isNotEmpty ||
        __scalarControlWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent({bool alsoCheckChildren = false}) {
    bool active = false;
    // Filter
    // if (block.filterModel != null) {
    //   active = block.filterModel!.ui.hasActiveUIComponent();
    //   if (active) {
    //     return true;
    //   }
    // }
    // Scalar Fragment:
    active = hasActiveScalarFragment(alsoCheckChildren: false);
    if (active) {
      return true;
    }
    // ControlBar:
    active = hasActiveControlBarWidget();
    if (active) {
      return true;
    }
    //
    if (alsoCheckChildren) {
      for (Scalar childScalar in scalar._childScalars) {
        active = childScalar.ui.hasActiveUIComponent(
          alsoCheckChildren: alsoCheckChildren,
        );
        if (active) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in __scalarControlWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
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
    updateControlWidgets(force: force);
    updateFragmentWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveScalarFragment({required bool alsoCheckChildren}) {
    for (State widgetState in __scalarFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = __scalarFragmentWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    if (alsoCheckChildren) {
      for (Scalar childBlock in scalar._childScalars) {
        bool active =
            childBlock.ui.hasActiveScalarFragment(alsoCheckChildren: true);
        if (active) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlBarWidget() {
    for (State widgetState in __scalarControlWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = __scalarControlWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    __scalarControlWidgetStates[widgetState] = isShowing;
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
    __scalarControlWidgetStates.remove(widgetState);
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
    __scalarFragmentWidgetStates[widgetState] = isShowing;
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
}
