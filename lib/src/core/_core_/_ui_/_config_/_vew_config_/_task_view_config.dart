part of '../../../core.dart';

class TaskViewConfig extends ViewConfig {
  final TaskViewContext taskViewContext;

  const TaskViewConfig({
    super.enableKeyboardNavigation = false,
    super.mouseFocusPolicy = ViewMouseFocusPolicy.strictNavigationOnly,
    super.quickSuggestionMode = QuickSuggestionMode.none,
    this.taskViewContext = TaskViewContext.initData,
  });
}
