part of '../core.dart';

class _StorageUiComponents extends _UiComponents {
  final _Storage storage;

  final Map<_RefreshableWidgetState, bool>
      __refreshableStorageSectionViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _StorageUiComponents({required this.storage});

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent() {
    for (_RefreshableWidgetState widgetState
        in __refreshableStorageSectionViewStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible =
          __refreshableStorageSectionViewStates[widgetState] ?? false;
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
    bool hasMounted = __refreshableStorageSectionViewStates.isNotEmpty;
    if (hasMounted) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents() {
    updateAllStorageSectionViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllStorageSectionViews() {
    for (_RefreshableWidgetState widgetState
        in __refreshableStorageSectionViewStates.keys) {
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
    __refreshableStorageSectionViewStates[widgetState] = isVisible;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    __refreshableStorageSectionViewStates.remove(widgetState);
  }
}
