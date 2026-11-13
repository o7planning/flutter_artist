part of '../../../core.dart';

class ProzessControlBarConfig extends ControlBarConfig {
  final ProzessViewContext prozessViewContext;
  final ProzessScreenNavigationContext? screenNavigationContext;

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
    super.enableKeyboardNavigation = false,
    this.prozessViewContext = ProzessViewContext.initData,
    this.screenNavigationContext,
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

  const ProzessControlBarConfig.allEnabled({
    super.enableKeyboardNavigation = false,
    this.prozessViewContext = ProzessViewContext.initData,
    this.screenNavigationContext,
  })
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
