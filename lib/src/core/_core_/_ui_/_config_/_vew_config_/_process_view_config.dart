part of '../../../core.dart';

class ProzessViewConfig extends ViewConfig {
  final ProzessViewContext prozessViewContext;

  const ProzessViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.prozessViewContext = ProzessViewContext.initData,
  });
}
