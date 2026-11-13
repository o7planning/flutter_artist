part of '../../../core.dart';

class TaskFormViewConfig extends FormViewConfig {
  final TaskScreenNavigationContext? screenNavigationContext;

  @override
  final bool circularFocusTraversal;

  const TaskFormViewConfig({
    this.screenNavigationContext,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.circularFocusTraversal = true,
  });
}
