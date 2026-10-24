part of '../../core.dart';

class TaskControlBarConfig {
  final bool allowBackButton;
  final bool allowRestartButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  final NavigationIntent? restartNavigationIntent;
  final NavigationIntent? submitNavigationIntent;

  const TaskControlBarConfig({
    this.allowBackButton = false,
    this.allowRestartButton = false,
    this.allowSubmitButton = false,
    this.allowDebugFormModelInspectorButton = false,
    this.restartNavigationIntent,
    this.submitNavigationIntent,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled({
    this.restartNavigationIntent,
    this.submitNavigationIntent,
  })
      : allowBackButton = true,
        allowRestartButton = true,
        allowSubmitButton = true,
        allowDebugFormModelInspectorButton = true;
}
