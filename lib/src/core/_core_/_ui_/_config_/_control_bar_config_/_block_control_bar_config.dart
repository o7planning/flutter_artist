part of '../../../core.dart';


class BlockControlBarConfig extends ControlBarConfig {
  final BlockViewContext blockViewContext;
  final BlockScreenNavigationContext? screenNavigationContext;

  final bool allowRefreshButton;
  final bool allowQueryButton;
  final bool allowCreateButton;
  final bool allowEditButton;
  final bool allowSaveButton;
  final bool allowResetFormButton;
  final bool allowDeleteButton;
  final bool allowBackButton;
  final bool allowDebugFormModelInspectorButton;
  final bool allowDebugFilterCriteriaInspectorButton;
  final bool allowDebugButton;

  const BlockControlBarConfig({
    super.enableKeyboardNavigation = false,
    this.blockViewContext = BlockViewContext.items,
    this.screenNavigationContext,
    required this.allowRefreshButton,
    required this.allowQueryButton,
    required this.allowCreateButton,
    this.allowEditButton = false,
    required this.allowSaveButton,
    required this.allowResetFormButton,
    required this.allowDeleteButton,
    required this.allowBackButton,
    required this.allowDebugFormModelInspectorButton,
    this.allowDebugFilterCriteriaInspectorButton = false,
    this.allowDebugButton = false,
  });
}
