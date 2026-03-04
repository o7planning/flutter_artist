part of '../core.dart';

class _StorageUiComponents extends _UiComponents {
  final _Storage storage;

  final Map<_ContextProviderViewState, bool>
      __refreshableStorageSectionViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _StorageUiComponents({required this.storage});

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent() {
    for (_ContextProviderViewState widgetState
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
    for (_ContextProviderViewState widgetState
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
    required _ContextProviderViewState widgetState,
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
