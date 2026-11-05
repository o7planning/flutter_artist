part of '../../../core.dart';

class TaskViewConfig {
  final TaskViewContext taskViewContext;
  final QuickSuggestionMode quickSuggestionMode;

  const TaskViewConfig({
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.taskViewContext = TaskViewContext.initData,
  });
}
