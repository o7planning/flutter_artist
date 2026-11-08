part of '../../../core.dart';

class ProzessFormViewConfig extends FormViewConfig {
  final QuickSuggestionMode quickSuggestionMode;
  final ProzessScreenNavigationContext? screenNavigationContext;

  @override
  final bool circularFocusTraversal;

  const ProzessFormViewConfig({
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.screenNavigationContext,
    this.circularFocusTraversal = true,
  });
}
