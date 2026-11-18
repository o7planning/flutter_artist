part of '../../../core.dart';

abstract class ControlBarConfig extends ViewConfig {
  const ControlBarConfig({
    required super.enableKeyboardNavigation,
    super.focusIndicatorConfig,
  }) : super(
    quickSuggestionMode: QuickSuggestionMode.none,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
  );
}
