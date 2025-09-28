part of '../core.dart';

class _StorageFreezeMan {
  final Map<_RefreshableWidgetState, bool> _freezingAgentWidgetStateMap = {};

  _StorageFreezeMan();

  bool get isFreezing {
    final m = {..._freezingAgentWidgetStateMap};
    for (_RefreshableWidgetState widgetState in m.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool isShowing = _freezingAgentWidgetStateMap[widgetState] ?? false;
      if (isShowing) {
        return true;
      }
    }
    return false;
  }

  void _onVisibilityChanged({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    if (_freezingAgentWidgetStateMap.containsKey(widgetState)) {
      _freezingAgentWidgetStateMap[widgetState] = isShowing;
      _recheckFreezingState();
    }
  }

  void _onWidgetStateDisposed({
    required _RefreshableWidgetState widgetState,
  }) {
    if (_freezingAgentWidgetStateMap.containsKey(widgetState)) {
      _freezingAgentWidgetStateMap.remove(widgetState);
      _recheckFreezingState();
    }
  }

  ///
  /// Check to execute delayed reaction.
  ///
  void _recheckFreezingState() {
    //
  }

  void createFreezingAgentWidgetState({
    required Shelf shelf,
    required bool findBlockFragment,
    required bool findForm,
    required bool findScalarFragment,
  }) {
    Map<_RefreshableWidgetState, XState> map =
        shelf.ui._findMountedWidgetStates(
      withBlockFragment: true,
      withScalarFragment: true,
      withPagination: true,
      withFilter: false,
      withForm: true,
      withBlockControlBar: true,
      withScalarControlBar: true,
      withControl: false,
      activeOnly: true,
    );
  }
}
