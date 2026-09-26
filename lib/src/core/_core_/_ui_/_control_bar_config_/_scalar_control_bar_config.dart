part of '../../core.dart';

class ScalarControlBarConfig {
  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterCriteriaInspectorButton;

  const ScalarControlBarConfig({
    required this.allowQueryButton,
    required this.allowBackButton,
    this.allowDebugFilterCriteriaInspectorButton = false,
  });
}
