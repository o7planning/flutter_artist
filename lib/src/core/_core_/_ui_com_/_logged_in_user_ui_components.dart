part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for global logged-in user widgets (e.g., [LoggedInUserBuilder]).
///
/// Serves as the runtime bridge between user identity changes and reactive user-dependent UI views.
class _LoggedInUserUiComponents extends _UiComponents {
  // Registered views: LoggedInUserBuilder widget states and their visibility flags.
  final Map<_ContextProviderViewState, bool> _loggedInUserWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _LoggedInUserUiComponents();

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered logged-in user views.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ..._loggedInUserWidgetStates.keys,
    ];
    return list.map((v) => v.faRoute).nonNulls.toList().toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any logged-in user view is currently mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return _loggedInUserWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any logged-in user view is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    for (final _ContextProviderViewState widgetState
        in _loggedInUserWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible = _loggedInUserWidgetStates[widgetState] ?? false;
      if (visible) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted logged-in user views upon authentication state changes.
  // OLD: updateAllUiComponents
  void refreshAllViews() {
    for (final _ContextProviderViewState widgetState
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

  void _removeLoggedInUserWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    _loggedInUserWidgetStates.remove(widgetState);
  }
}
