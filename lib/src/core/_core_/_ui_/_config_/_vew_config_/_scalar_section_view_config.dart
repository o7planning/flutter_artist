part of '../../../core.dart';

class ScalarSectionViewConfig {
  final QuickSuggestionMode quickSuggestionMode;
  final ScalarScreenNavigationContext? screenNavigationContext;
  final ScalarViewContext scalarContextType;

  const ScalarSectionViewConfig({
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.scalarContextType = ScalarViewContext.value,
    this.screenNavigationContext,
  });
}
