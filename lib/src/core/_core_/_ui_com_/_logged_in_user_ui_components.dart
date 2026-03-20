part of '../core.dart';

class _LoggedInUserUiComponents extends _UiComponents {
  final Map<_ContextProviderViewState, bool> _loggedInUserWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _LoggedInUserUiComponents();


  // ***************************************************************************
  // ***************************************************************************

  @override
  Set<String> get routeNames {
    List<_ContextProviderViewState> list = [
      ..._loggedInUserWidgetStates.keys,
    ];
    return list.map((v) => v.routeName).nonNulls.toList().toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return _loggedInUserWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents() {
    for (_ContextProviderViewState widgetState
        in _loggedInUserWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addLoggedInUserWidgetState({
    required _ContextProviderViewState widgetState,
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
