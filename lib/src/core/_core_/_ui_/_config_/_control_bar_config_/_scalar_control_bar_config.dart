part of '../../../core.dart';

class ScalarControlBarConfig {
  final ScalarViewContext? scalarContextType;
  final ScalarScreenNavigationContext? screenNavigationContext;

  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterCriteriaInspectorButton;

  const ScalarControlBarConfig({
    this.scalarContextType = ScalarViewContext.value,
    this.screenNavigationContext,
    required this.allowQueryButton,
    required this.allowBackButton,
    this.allowDebugFilterCriteriaInspectorButton = false,
  });
}
