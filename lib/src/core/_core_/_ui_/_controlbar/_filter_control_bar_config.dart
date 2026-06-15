part of '../../core.dart';

class FilterControlBarConfig {
  final bool allowQueryButton;
  final bool allowBackButton;
  final bool allowDebugFilterModelInspectorButton;

  const FilterControlBarConfig({
    this.allowQueryButton = false,
    this.allowBackButton = false,
    this.allowDebugFilterModelInspectorButton = true,
  });
}
