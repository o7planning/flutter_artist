part of '../../../core.dart';

class TaskControlBarConfig {
  final bool allowBackButton;
  final bool allowRestartButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  const TaskControlBarConfig({
    this.allowBackButton = false,
    this.allowRestartButton = false,
    this.allowSubmitButton = false,
    this.allowDebugFormModelInspectorButton = false,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowRestartButton = true,
        allowSubmitButton = true,
        allowDebugFormModelInspectorButton = true;
}
