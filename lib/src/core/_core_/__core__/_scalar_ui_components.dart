part of '../core.dart';

class _ScalarUIComponents {
  final Scalar scalar;

  final Map<_RefreshableWidgetState, bool> _scalarFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _scalarControlWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _ScalarUIComponents({required this.scalar});

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _scalarFragmentWidgetStates.isNotEmpty ||
        _scalarControlWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    return _hasActiveScalarFragmentWidgetState() ||
        _hasActiveControlWidgetState();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveScalarFragmentWidgetState() {
    for (State widgetState in _scalarFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _scalarFragmentWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasActiveControlWidgetState() {
    for (State widgetState in _scalarControlWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _scalarControlWidgetStates[widgetState] ?? false;
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
    _scalarControlWidgetStates[widgetState] = isShowing;
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
    _scalarControlWidgetStates.remove(widgetState);
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
    _scalarFragmentWidgetStates[widgetState] = isShowing;
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
    _scalarFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      scalar._fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in _scalarControlWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateFragmentWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in _scalarFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
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
}
