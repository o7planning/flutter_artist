part of '../../../core.dart';

class BlockItemsViewConfig {
  /// Policy controlling whether clicking inside this view transfers keyboard focus to it.
  final ViewMouseFocusPolicy mouseFocusPolicy;

  final BlockScreenNavigationContext? screenNavigationContext;

  final QuickSuggestionMode quickSuggestionMode;

  final BlockViewContext blockViewContext;

  final ViewFocusStyle focusStyle;

  /// Whether this items view can receive keyboard focus and handle Up/Down arrow navigation.
  final bool enableKeyboardNavigation;

  const BlockItemsViewConfig({
    this.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    this.screenNavigationContext,
    this.enableKeyboardNavigation = true,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockViewContext = BlockViewContext.items,
    this.focusStyle = ViewFocusStyle.leftAccentBar,
  });
}
