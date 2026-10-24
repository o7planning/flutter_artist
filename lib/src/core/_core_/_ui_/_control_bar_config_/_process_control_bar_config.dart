part of '../../core.dart';

class ProzessControlBarConfig {
  final bool allowBackButton;
  final bool allowCancelButton;
  final bool allowMoveToPreviousStageButton;
  final bool allowMoveToNextStageButton;
  final bool allowResetButton;
  final bool allowLoadStageInitDataButton;
  final bool allowSubmitStageButton;
  final bool allowDebugInspectorButton;
  final bool allowDebugFormButton;

  const ProzessControlBarConfig({
    this.allowBackButton = false,
    this.allowCancelButton = false,
    this.allowMoveToPreviousStageButton = false,
    this.allowMoveToNextStageButton = false,
    this.allowResetButton = false,
    this.allowLoadStageInitDataButton = false,
    this.allowSubmitStageButton = false,
    this.allowDebugInspectorButton = false,
    this.allowDebugFormButton = false,
  });

  const ProzessControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowCancelButton = true,
        allowMoveToPreviousStageButton = true,
        allowMoveToNextStageButton = true,
        allowResetButton = true,
        allowLoadStageInitDataButton = true,
        allowSubmitStageButton = true,
        allowDebugInspectorButton = true,
        allowDebugFormButton = true;
}
