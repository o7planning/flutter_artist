part of '../core.dart';

class _UiComponentsDebug {
  final _UiComponents owner;

  _UiComponentsDebug(this.owner);

  Map<IContextProviderViewState, XState> findAllMountedWidgetStates() {
    return owner._debugFindAllMountedWidgetStates();
  }
}
