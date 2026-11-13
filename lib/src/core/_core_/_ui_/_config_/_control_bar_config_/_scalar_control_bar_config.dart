part of '../../../core.dart';

class ScalarControlBarConfig extends ControlBarConfig {
  final ScalarViewContext? scalarContextType;
  final ScalarScreenNavigationContext? screenNavigationContext;

  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterCriteriaInspectorButton;

  const ScalarControlBarConfig({
    super.enableKeyboardNavigation = false,
    this.scalarContextType = ScalarViewContext.value,
    this.screenNavigationContext,
    required this.allowQueryButton,
    required this.allowBackButton,
    this.allowDebugFilterCriteriaInspectorButton = false,
  });
}
