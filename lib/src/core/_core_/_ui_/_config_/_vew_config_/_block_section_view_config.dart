part of '../../../core.dart';

class BlockSectionViewConfig extends ViewConfig {
  final BlockViewContext blockViewContext;

  const BlockSectionViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.blockViewContext = BlockViewContext.items,
  });
}
