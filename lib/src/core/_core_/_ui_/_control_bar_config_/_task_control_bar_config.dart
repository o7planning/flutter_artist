part of '../../core.dart';

class TaskControlBarConfig {
  final bool allowBackButton;
  final bool allowLoadInitDataButton;
  final bool allowSubmitButton;
  final bool allowDebugFormModelInspectorButton;

  final NavigationIntent? loadInitDataNavigationIntent;
  final NavigationIntent? submitNavigationIntent;

  const TaskControlBarConfig({
    this.allowBackButton = false,
    this.allowLoadInitDataButton = false,
    this.allowSubmitButton = false,
    this.allowDebugFormModelInspectorButton = false,
    this.loadInitDataNavigationIntent,
    this.submitNavigationIntent,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled({
    this.loadInitDataNavigationIntent,
    this.submitNavigationIntent,
  })  : allowBackButton = true,
        allowLoadInitDataButton = true,
        allowSubmitButton = true,
        allowDebugFormModelInspectorButton = true;
}
