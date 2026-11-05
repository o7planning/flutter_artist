part of '../../../core.dart';

class TaskFormViewConfig  extends FormViewConfig{
  final TaskScreenNavigationContext? screenNavigationContext;
  final QuickSuggestionMode quickSuggestionMode;

  @override
  final bool circularFocusTraversal;

  const TaskFormViewConfig({
    this.screenNavigationContext,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.circularFocusTraversal = true,
  });
}
