part of '../../../core.dart';

class FilterControlBarConfig {
  final FilterScreenNavigationContext? screenNavigationContext;

  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterModelInspectorButton;

  const FilterControlBarConfig({
    this.screenNavigationContext,
    this.allowQueryButton = false,
    this.allowBackButton = false,
    this.allowDebugFilterModelInspectorButton = true,
  });
}
