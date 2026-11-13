part of '../../../core.dart';

class ProzessFormViewConfig extends FormViewConfig {
  final ProzessScreenNavigationContext? screenNavigationContext;

  @override
  final bool circularFocusTraversal;

  const ProzessFormViewConfig({
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.screenNavigationContext,
    this.circularFocusTraversal = true,
  });
}
