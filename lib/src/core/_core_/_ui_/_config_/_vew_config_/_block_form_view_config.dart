part of '../../../core.dart';

class BlockFormViewConfig extends FormViewConfig {
  final BlockScreenNavigationContext? screenNavigationContext;

  @override
  final bool circularFocusTraversal;

  const BlockFormViewConfig({
    this.screenNavigationContext,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.circularFocusTraversal = true,
  });
}
