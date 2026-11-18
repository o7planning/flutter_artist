part of '../../../core.dart';

class BlockItemsViewConfig extends ViewConfig {
  final BlockScreenNavigationContext? screenNavigationContext;

  final BlockViewContext blockViewContext;

  const BlockItemsViewConfig({
    super.enableKeyboardNavigation = true,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    this.screenNavigationContext,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockViewContext = BlockViewContext.items,
    super.focusIndicatorConfig,
  });
}
