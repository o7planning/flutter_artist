part of '../core.dart';

class HookConfig {
  final HookHiddenBehavior hiddenBehavior;

  const HookConfig({
    this.hiddenBehavior = HookHiddenBehavior.none,
  });

  HookConfig copy() {
    return HookConfig(hiddenBehavior: hiddenBehavior);
  }
}
