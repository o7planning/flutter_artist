part of '../core.dart';

class _FormUiComponents extends _UiComponents {
  final FormModel formModel;

  final Map<_ContextProviderViewState, XState> __formWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _FormUiComponents({required this.formModel});

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUiComponents({bool force = false}) {
    __updateFormWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  bool hasMountedUiComponent() {
    return __formWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUiComponent() {
    return hasActiveUiComponentWithContextKind(
      contextKind: null,
    );
  }

  bool hasActiveUiComponentWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (_ContextProviderViewState widgetState in __formWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __formWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedFormWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: __formWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFormViewBuildingState({
    required _ContextProviderViewState widgetState,
    required bool isBuilding,
  }) {
    __formWidgetStates.update(
      widgetState,
      (xState) => xState.._setBuilding(isBuilding),
      ifAbsent: () => XState().._setBuilding(isBuilding),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addFormWidgetState({
    required _ContextProviderViewState widgetState,
    required final bool isVisible,
  }) {
    bool isVisibleOLD = __formWidgetStates[widgetState]?.isVisible ?? false;
    __formWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    if (!isVisibleOLD && isVisible) {
      // formModel.shelf._startLoadDataForLazyUiComponentsIfNeed();
      // LOGIC: #0000
      FlutterArtist.storage._naturalQueryQueue.addShelf(formModel.shelf);
    }
    if (isVisible) {
      FlutterArtist.storage._addRecentShelf(formModel.shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFormWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __formWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_ContextProviderViewState> _getMountedFormWidgetStates() {
    List<_ContextProviderViewState> ret = [];
    for (_ContextProviderViewState widgetState in [
      ...__formWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding(
      {required _ContextProviderViewState widgetState}) {
    return __formWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to refresh Widgets..
  ///
  void __updateFormWidgets({bool force = false}) {
    List<_ContextProviderViewState> list = _getMountedFormWidgetStates();
    for (_ContextProviderViewState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState(force: force);
      }
    }
  }
}
