part of '../core.dart';

class _LoggedInUserUiComponents extends _UiComponents {
  final Map<_RefreshableWidgetState, bool> _loggedInUserWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _LoggedInUserUiComponents();

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return _loggedInUserWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents() {
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
    required bool isVisible,
  }) {
    _loggedInUserWidgetStates[widgetState] = isVisible;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeLoggedInUserWidgetState({required State widgetState}) {
    _loggedInUserWidgetStates.remove(widgetState);
  }
}
