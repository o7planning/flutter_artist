part of '../../../core.dart';

class ScalarValueViewConfig extends ViewConfig {
  final ScalarScreenNavigationContext? screenNavigationContext;

  const ScalarValueViewConfig({
    super.enableKeyboardNavigation = true,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.screenNavigationContext,
    super.focusIndicatorConfig,
  });
}
