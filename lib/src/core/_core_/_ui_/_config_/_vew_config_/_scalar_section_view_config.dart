part of '../../../core.dart';

class ScalarSectionViewConfig extends ViewConfig {
  final ScalarScreenNavigationContext? screenNavigationContext;
  final ScalarViewContext scalarContextType;

  const ScalarSectionViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.scalarContextType = ScalarViewContext.value,
    this.screenNavigationContext,
  });
}
