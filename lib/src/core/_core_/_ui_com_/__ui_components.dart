part of '../core.dart';

abstract class _UiComponents {
  bool hasMountedUiComponent();

  Map<_ContextProviderViewState, XState> ___findMountedWidgetStates({
    required Map<_ContextProviderViewState, XState> widgetStates,
    required bool activeOnly,
  }) {
    final Map<_ContextProviderViewState, XState> ret = {};
    for (_ContextProviderViewState ws in widgetStates.keys) {
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
