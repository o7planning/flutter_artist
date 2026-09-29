part of '../../core.dart';

class TaskControlBarConfig {
  final bool allowBackButton;
  final bool allowLoadInitDataButton;
  final bool allowSubmitButton;

  const TaskControlBarConfig({
    this.allowBackButton = false,
    this.allowLoadInitDataButton = true,
    this.allowSubmitButton = true,
  });

  // TODO: Rename?
  const TaskControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowLoadInitDataButton = true,
        allowSubmitButton = true;
}
