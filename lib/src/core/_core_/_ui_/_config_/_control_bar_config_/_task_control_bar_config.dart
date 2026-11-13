part of '../../../core.dart';

class TaskControlBarConfig extends ControlBarConfig {
  final TaskViewContext? taskViewContext;
  final TaskScreenNavigationContext? screenNavigationContext;

  final bool allowBackButton;
  final bool allowRestartButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  const TaskControlBarConfig({
    super.enableKeyboardNavigation = false,
    this.taskViewContext = TaskViewContext.initData,
    this.screenNavigationContext,
    this.allowBackButton = false,
    this.allowRestartButton = false,
    this.allowSubmitButton = false,
    this.allowDebugFormModelInspectorButton = false,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled({
    super.enableKeyboardNavigation = false,
    this.taskViewContext = TaskViewContext.initData,
    this.screenNavigationContext,
  })  : allowBackButton = true,
        allowRestartButton = true,
        allowSubmitButton = true,
        allowDebugFormModelInspectorButton = true;
}
