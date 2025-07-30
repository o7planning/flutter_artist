part of '../core.dart';

class _LoggedInUserUIComponents {
  final Map<_RefreshableWidgetState, bool> _loggedInUserWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _LoggedInUserUIComponents();

  // ***************************************************************************
  // ***************************************************************************

  void updateWidgets() {
    for (_RefreshableWidgetState widgetState
        in _loggedInUserWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addLoggedInUserWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _loggedInUserWidgetStates[widgetState] = isShowing;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeLoggedInUserWidgetState({required State widgetState}) {
    _loggedInUserWidgetStates.remove(widgetState);
  }
}
