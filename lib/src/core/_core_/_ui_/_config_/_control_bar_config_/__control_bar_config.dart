part of '../../../core.dart';

abstract class ControlBarConfig extends ViewConfig {
  const ControlBarConfig({
    required super.enableKeyboardNavigation,
  }) : super(
    quickSuggestionMode: QuickSuggestionMode.none,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
  );
}
