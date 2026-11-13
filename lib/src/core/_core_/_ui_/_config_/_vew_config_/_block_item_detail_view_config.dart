part of '../../../core.dart';

class BlockItemDetailViewConfig extends ViewConfig {
  final BlockViewContext blockViewContext;

  const BlockItemDetailViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.blockViewContext = BlockViewContext.itemDetail,
  });
}
