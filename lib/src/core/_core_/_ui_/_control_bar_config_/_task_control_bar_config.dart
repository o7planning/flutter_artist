part of '../../core.dart';

class TaskControlBarConfig {
  final bool allowBackButton;
  final bool allowLoadInitDataButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  const TaskControlBarConfig({
    this.allowBackButton = false,
    this.allowLoadInitDataButton = true,
    this.allowSubmitButton = true,
    this.allowDebugFormModelInspectorButton = false,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowLoadInitDataButton = true,
        allowSubmitButton = true,
  allowDebugFormModelInspectorButton=true;
}
