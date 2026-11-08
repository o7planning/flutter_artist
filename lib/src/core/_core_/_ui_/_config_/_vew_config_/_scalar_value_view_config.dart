part of '../../../core.dart';

class ScalarValueViewConfig {
  final QuickSuggestionMode quickSuggestionMode;
  final ScalarScreenNavigationContext? screenNavigationContext;

  const ScalarValueViewConfig({
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.screenNavigationContext,
  });
}
