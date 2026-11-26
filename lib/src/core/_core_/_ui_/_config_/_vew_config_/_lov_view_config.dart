part of '../../../core.dart';

class LovViewConfig extends ViewConfig {
  final LovViewContext lovViewContext;

  const LovViewConfig({
    super.enableKeyboardNavigation = true,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.clickToFocus,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.lovViewContext = LovViewContext.items,
    super.focusIndicatorConfig,
  });
}
