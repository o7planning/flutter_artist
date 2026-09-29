part of '../../core.dart';

class ProzessControlBarConfig {
  final bool allowBackButton;
  final bool allowCancelButton;
  final bool allowResetButton;
  final bool allowDebugInspectorButton;

  const ProzessControlBarConfig({
    this.allowBackButton = true,
    this.allowCancelButton = true,
    this.allowResetButton = false,
    this.allowDebugInspectorButton = true,
  });

  const ProzessControlBarConfig.allEnabled()
      : allowBackButton = true,
        allowCancelButton = true,
        allowResetButton = true,
        allowDebugInspectorButton = true;
}
