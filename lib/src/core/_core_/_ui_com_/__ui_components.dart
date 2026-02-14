part of '../core.dart';

abstract class _UiComponents {
  bool hasMountedUiComponent();

  Map<_RefreshableWidgetState, XState> ___findMountedWidgetStates({
    required Map<_RefreshableWidgetState, XState> widgetStates,
    required bool activeOnly,
  }) {
    final Map<_RefreshableWidgetState, XState> ret = {};
    for (_RefreshableWidgetState ws in widgetStates.keys) {
      if (ws.mounted) {
        XState xState = widgetStates[ws]!;
        if (activeOnly && xState.isVisible) {
          ret[ws] = xState;
        } else {
          ret[ws] = xState;
        }
      }
    }
    return ret;
  }
}
