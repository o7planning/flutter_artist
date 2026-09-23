part of '../core.dart';

/// Coordinates UI representation registrations, visibility tracking, and view rebuild cycles
/// for an individual [BlockFormModel].
///
/// Serves as the runtime bridge between reactive form view widgets (e.g., [FormView],
/// [FormViewBuilder]) and the underlying form data state.
class _FormUiComponents extends _UiComponents {
  /// The owner form model bound to this UI coordinator.
  final BlockFormModel formModel;

  // Registered views: FormView / FormViewBuilder widget states.
  final Map<_ContextProviderViewState, XState> _formViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _FormUiComponents({required this.formModel});

  // ***************************************************************************
  // ***************************************************************************

  /// Returns all active Flutter FormBuilderState instances currently mounted in visible form views.
  // OLD: _activeFormBuilderStates
  List<FormBuilderState> get _visibleFormBuilderStates {
    final List<FormBuilderState> forms = [];
    for (final _ContextProviderViewState state in _formViewWidgetStates.keys) {
      if (state.mounted && state is _FormViewBuilderState) {
        final formState = state.formKey.currentState;
        if (formState != null) {
          forms.add(formState);
        }
      }
    }
    return forms;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Aggregates all navigation route keys declared across registered form views.
  @override
  Set<FaRouteData> get faRouteDatas {
    final List<_ContextProviderViewState> list = [
      ..._formViewWidgetStates.keys,
    ];
    return list.map((v) => v.faRoute).nonNulls.toList().toSet();
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted view representations associated with this form model.
  // OLD: updateAllUiComponents
  void refreshAllViews({bool force = false}) {
    refreshFormViews(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether any FormView connected to this form model is currently mounted in the widget tree.
  // OLD: hasMountedUiComponent
  @override
  bool hasMountedViews() {
    return _formViewWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks if any FormView connected to this form model is actively visible on screen.
  // OLD: hasActiveUiComponent
  bool hasVisibleViews() {
    return hasVisibleViewsWithContextKind(
      contextKind: null,
    );
  }

  /// Checks if any FormView matching the specified [contextKind] is currently visible.
  // OLD: hasActiveUiComponentWithContextKind
  bool hasVisibleViewsWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in _formViewWidgetStates.keys) {
      if (!widgetState.mounted) {
        continue;
      }
      final bool visible =
          _formViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) {
        continue;
      }
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Locates the class name of the actively visible FormView for diagnostic inspection.
  String? findVisibleFormView() {
    for (final widgetState in _formViewWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final visible = _formViewWidgetStates[widgetState]?.isVisible ?? false;
      if (visible) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  /// Diagnostic inspection alias resolving the visible form view.
  String? findVisibleView() => findVisibleFormView();

  // ***************************************************************************
  // ***************************************************************************

  Map<_ContextProviderViewState, XState> _findMountedFormWidgetStates({
    required bool activeOnly,
  }) {
    return ___findMountedWidgetStates(
      widgetStates: _formViewWidgetStates,
      activeOnly: activeOnly,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFormViewBuildingState({
    required _ContextProviderViewState widgetState,
    required bool isBuilding,
  }) {
    _formViewWidgetStates.update(
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
    final bool isVisibleOld =
        _formViewWidgetStates[widgetState]?.isVisible ?? false;
    _formViewWidgetStates.update(
      widgetState,
      (xState) => xState.._setShowing(isVisible),
      ifAbsent: () => XState().._setShowing(isVisible),
    );
    if (!isVisibleOld && isVisible) {
      // LOGIC: #0000
      FlutterArtist.storage._lazyUiComponentTriggerQueue.addShelf(formModel.shelf);
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
    _formViewWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_ContextProviderViewState> _getMountedFormWidgetStates() {
    final List<_ContextProviderViewState> ret = [];
    for (final _ContextProviderViewState widgetState in [
      ..._formViewWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isWidgetStateBuilding({
    required _ContextProviderViewState widgetState,
  }) {
    return _formViewWidgetStates[widgetState]?.isBuilding ?? false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds all mounted form view widgets.
  // OLD: __updateFormWidgets
  void refreshFormViews({bool force = false}) {
    final List<_ContextProviderViewState> list = _getMountedFormWidgetStates();
    for (final _ContextProviderViewState formWidgetState in list) {
      if (formWidgetState.mounted) {
        formWidgetState.refreshState(force: force);
      }
    }
  }
}
