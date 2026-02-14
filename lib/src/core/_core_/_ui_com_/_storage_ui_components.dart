part of '../core.dart';

class _StorageUiComponents extends _UiComponents {
  final _Storage storage;

  final Map<_RefreshableWidgetState, bool> __refreshableStorageAreaViewStates =
      {};

  // ***************************************************************************
  // ***************************************************************************

  _StorageUiComponents({required this.storage});

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent() {
    for (_RefreshableWidgetState widgetState
        in __refreshableStorageAreaViewStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __refreshableStorageAreaViewStates[widgetState] ?? false;
      if (visible) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    bool hasMounted = __refreshableStorageAreaViewStates.isNotEmpty;
    if (hasMounted) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents() {
    updateAllStorageAreaViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllStorageAreaViews() {
    for (_RefreshableWidgetState widgetState
        in __refreshableStorageAreaViewStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      widgetState.refreshState(force: true);
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _addShelfWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isVisible,
  }) {
    __refreshableStorageAreaViewStates[widgetState] = isVisible;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    __refreshableStorageAreaViewStates.remove(widgetState);
  }
}
