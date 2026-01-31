part of '../core.dart';

class HookConfig {
  final HookHiddenAction onHideAction;

  const HookConfig({
    this.onHideAction = HookHiddenAction.none,
  });

  HookConfig copy() {
    return HookConfig(onHideAction: onHideAction);
  }
}
