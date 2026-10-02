part of '../core.dart';

abstract class _WorkNodeUiComponents extends _UiComponents {
  final Map<_ContextProviderViewState, XState> __contentViewWidgetStates = {};

  final Map<_ContextProviderViewState, XState> __controlBarWidgetStates = {};

  _WorkNodeUiComponents();

  // ***************************************************************************
  // ***************************************************************************

  String? findVisibleView();

  /// Checks if any UI view connected to this stage is actively visible on screen.
  bool hasVisibleViews() {
    return findVisibleView() != null;
  }

  /// Evaluates whether an active Form representation demands stage-level form context.
  bool hasFormContext() {
    return findVisibleFormContextView() != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  String? __findVisibleViewWithContextKind({
    required ContextKind? contextKind,
  });

  /// Resolves the class name of the view currently demanding the Form data context.
  String? findVisibleFormContextView() {
    return __findVisibleViewWithContextKind(contextKind: ContextKind.form);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasVisibleContentView() {
    return findVisibleContentView() != null;
  }

  /// Locates the class name of the actively visible content view.
  String? findVisibleContentView() {
    return findVisibleContentViewWithContextKind(contextKind: null);
  }

  /// Locates the class name of the actively visible content view filtered by context kind.
  String? findVisibleContentViewWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in __contentViewWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          __contentViewWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) continue;
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) {
        return getClassNameWithoutGenerics(widgetState.widget);
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasVisibleControlBar() {
    return hasVisibleControlBarWithContextKind(contextKind: null);
  }

  bool hasVisibleControlBarWithContextKind({
    required ContextKind? contextKind,
  }) {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (!widgetState.mounted) continue;
      final bool visible =
          __controlBarWidgetStates[widgetState]?.isVisible ?? false;
      if (!visible) continue;
      final bool ok = widgetState.isContextKind(contextKind);
      if (ok) return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Rebuilds active stage control bars.
  void refreshControlBars({bool force = false}) {
    for (final _ContextProviderViewState widgetState
        in __controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  void refreshContentViews({bool force = true}) {
    for (final _ContextProviderViewState state
        in __contentViewWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  /// Rebuilds all mounted views connected to this stage and its form model.
  void refreshAllViews({bool force = true});

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _ContextProviderViewState widgetState,
    required bool isVisible,
  });

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlBarWidgetState({
    required _ContextProviderViewState widgetState,
  }) {
    __controlBarWidgetStates.remove(widgetState);
  }
}
