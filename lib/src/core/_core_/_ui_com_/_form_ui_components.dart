part of '../core.dart';

class _FormUiComponents extends _UiComponents {
  final FormModel formModel;

  final Map<_RefreshableWidgetState, XState> __formWidgetStates = {};

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
    return hasActiveUiComponentWithRepresentativeType(
      representativeType: null,
    );
  }

  bool hasActiveUiComponentWithRepresentativeType({
    required RepresentativeType? representativeType,
  }) {
    for (_RefreshableWidgetState widgetState in __formWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      bool visible = __formWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      bool ok = widgetState.isRepresentativeType(representativeType);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, XState> _findMountedFormWidgetStates({
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
    required _RefreshableWidgetState widgetState,
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
    required _RefreshableWidgetState widgetState,
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
    required _RefreshableWidgetState widgetState,
  }) {
    __formWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_RefreshableWidgetState> _getMountedFormWidgetStates() {
    List<_RefreshableWidgetState> ret = [];
    for (_RefreshableWidgetState widgetState in [...__formWidgetStates.keys]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({required _RefreshableWidgetState widgetState}) {
    return __formWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Call this method to refresh Widgets..
  ///
  void __updateFormWidgets({bool force = false}) {
    List<_RefreshableWidgetState> list = _getMountedFormWidgetStates();
    for (_RefreshableWidgetState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState(force: force);
      }
    }
  }
}
