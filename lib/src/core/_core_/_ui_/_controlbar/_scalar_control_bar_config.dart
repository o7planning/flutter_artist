part of '../../core.dart';

class ScalarControlBarConfig {
  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterCriteriaViewerButton;

  const ScalarControlBarConfig({
    required this.allowQueryButton,
    required this.allowBackButton,
    this.allowDebugFilterCriteriaViewerButton = false,
  });
}
