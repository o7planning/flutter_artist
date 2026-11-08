part of '../../../core.dart';

class TaskControlBarConfig {
  final TaskViewContext? taskViewContext;
  final TaskScreenNavigationContext? screenNavigationContext;

  final bool allowBackButton;
  final bool allowRestartButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  const TaskControlBarConfig({
    this.taskViewContext = TaskViewContext.initData,
    this.screenNavigationContext,
    this.allowBackButton = false,
    this.allowRestartButton = false,
    this.allowSubmitButton = false,
    this.allowDebugFormModelInspectorButton = false,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled({
    this.taskViewContext = TaskViewContext.initData,
    this.screenNavigationContext,
  })  : allowBackButton = true,
        allowRestartButton = true,
        allowSubmitButton = true,
        allowDebugFormModelInspectorButton = true;
}
