part of '../../core.dart';

class ProzessControlBarConfig {
  final bool allowBackButton;
  final bool allowCancelButton;
  final bool allowResetButton;
  final bool allowLoadCurrentStageInitDataButton;
  final bool submitCurrentStageButton;
  final bool allowDebugInspectorButton;

  const ProzessControlBarConfig({
    this.allowBackButton = false ,
    this.allowCancelButton = false,
    this.allowResetButton = false,
    this.allowLoadCurrentStageInitDataButton= false,
    this.submitCurrentStageButton=false,
    this.allowDebugInspectorButton = false,
  });

  const ProzessControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowCancelButton = true,
        allowResetButton = true,
        allowLoadCurrentStageInitDataButton=true,
        submitCurrentStageButton=true,
        allowDebugInspectorButton = true;
}
