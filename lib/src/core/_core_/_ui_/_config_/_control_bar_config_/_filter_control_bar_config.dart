part of '../../../core.dart';

class FilterControlBarConfig extends ControlBarConfig {
  final FilterScreenNavigationContext? screenNavigationContext;

  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterModelInspectorButton;

  const FilterControlBarConfig({
    super.enableKeyboardNavigation = false,
    this.screenNavigationContext,
    this.allowQueryButton = false,
    this.allowBackButton = false,
    this.allowDebugFilterModelInspectorButton = true,
  });
}
