part of '../../../core.dart';

class ScalarValueViewConfig extends ViewConfig {
  final ScalarScreenNavigationContext? screenNavigationContext;

  const ScalarValueViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.screenNavigationContext,
  });
}
