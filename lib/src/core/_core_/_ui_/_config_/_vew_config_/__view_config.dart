part of '../../../core.dart';

abstract class ViewConfig {
  final QuickSuggestionMode quickSuggestionMode;

  final bool enableKeyboardNavigation;

  final ViewMouseFocusPolicy mouseFocusPolicy;

  /// Optional per-view override for visual focus indicators (dot and/or tint overlay).
  /// When `null`, falls back to the global default [FocusIndicatorConfig].
  final FocusIndicatorConfig? focusIndicatorConfig;

  /// Whether this view participates in region-level focus tracking and
  /// `Ctrl + Tab` traversal.
  bool get enableRegionFocus => enableKeyboardNavigation;

  /// Whether descendant widgets inside this view (such as form input fields)
  /// are allowed to acquire focus individually.
  bool get allowDescendantFocus => false;

  const ViewConfig({
    required this.quickSuggestionMode,
    required this.enableKeyboardNavigation,
    required this.mouseFocusPolicy,
    required this.focusIndicatorConfig,
  });
}

class _InternalViewConfig extends ViewConfig {
  const _InternalViewConfig()
      : super(
          quickSuggestionMode: QuickSuggestionMode.none,
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
          focusIndicatorConfig: const FocusIndicatorConfig(enabled: false),
        );
}
