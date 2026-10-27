part of '../../core.dart';

class ProzessControlBarConfig {
  final bool allowBackButton;
  final bool allowCancelButton;
  final bool allowMoveToPreviousStageButton;
  final bool allowMoveToNextStageButton;
  final bool allowRestartProzessButton;
  final bool allowRestartViewingStageButton;
  final bool allowSubmitStageButton;
  final bool allowDebugInspectorButton;
  final bool allowDebugFormButton;

  const ProzessControlBarConfig({
    this.allowBackButton = false,
    this.allowCancelButton = false,
    this.allowMoveToPreviousStageButton = false,
    this.allowMoveToNextStageButton = false,
    this.allowRestartProzessButton = false,
    this.allowRestartViewingStageButton = false,
    this.allowSubmitStageButton = false,
    this.allowDebugInspectorButton = false,
    this.allowDebugFormButton = false,
  });

  const ProzessControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowCancelButton = true,
        allowMoveToPreviousStageButton = true,
        allowMoveToNextStageButton = true,
        allowRestartProzessButton = true,
        allowRestartViewingStageButton = true,
        allowSubmitStageButton = true,
        allowDebugInspectorButton = true,
        allowDebugFormButton = true;
}
