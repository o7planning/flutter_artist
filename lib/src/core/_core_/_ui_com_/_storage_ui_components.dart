part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// managed directly at the global [_Storage] level.
///
/// Serves as the runtime bridge between reactive storage section widgets (e.g., [StorageSectionView],
/// [StorageSectionViewBuilder]) and the underlying storage state.
class _StorageUiComponents extends _UiComponents {
  /// The global storage instance bound to this UI coordinator.
  final _Storage storage;

  // Registered views: StorageSectionView widget states.
  final Map<_ContextProviderViewState, bool> _storageSectionViewStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _StorageUiComponents({required this.storage});

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered storage section views.
  @override
  Set<FaRouteData> get faRouteDatas {
    return const {};
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any StorageSectionView is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    for (final _ContextProviderViewState widgetState
        in _storageSectionViewStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible = _storageSectionViewStates[widgetState] ?? false;
      if (visible) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any StorageSectionView is currently mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return _storageSectionViewStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted view representations managed directly at the storage level.
  // OLD: updateAllUiComponents
  void refreshAllViews() {
    refreshStorageSectionViews();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted storage section views.
  // OLD: updateAllStorageSectionViews
  void refreshStorageSectionViews() {
    for (final _ContextProviderViewState widgetState
        in _storageSectionViewStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      widgetState.refreshState(force: true);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _addShelfWidgetState
  void _addStorageSectionViewState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  }) {
    _storageSectionViewStates[widgetState] = isVisible;
  }

  // ***************************************************************************
  // ***************************************************************************

  // OLD: _removeShelfWidgetState
  void _removeStorageSectionViewState({
    required _ContextProviderViewState widgetState,
  }) {
    _storageSectionViewStates.remove(widgetState);
  }
}
