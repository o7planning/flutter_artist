part of '../../../core.dart';

class BlockItemsViewConfig extends ViewConfig {
  final BlockScreenNavigationContext? screenNavigationContext;

  final BlockViewContext blockViewContext;

  const BlockItemsViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    this.screenNavigationContext,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockViewContext = BlockViewContext.items,
  });
}
