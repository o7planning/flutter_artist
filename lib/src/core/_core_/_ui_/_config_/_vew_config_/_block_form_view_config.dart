part of '../../../core.dart';

class BlockFormViewConfig extends FormViewConfig {

  final BlockScreenNavigationContext? screenNavigationContext;
  final QuickSuggestionMode quickSuggestionMode;

  @override
  final bool circularFocusTraversal;


  const BlockFormViewConfig({
    this.screenNavigationContext,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.circularFocusTraversal = true,
  });
}
