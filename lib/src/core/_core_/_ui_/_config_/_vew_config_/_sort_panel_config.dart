part of '../../../core.dart';

class SortPanelConfig extends ViewConfig {
  final BlockViewContext blockViewContext;

  const SortPanelConfig({
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.blockViewContext = BlockViewContext.items,
  }) : super(
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
        );
}
