part of '../../../core.dart';

abstract class ViewConfig {
  final QuickSuggestionMode quickSuggestionMode;

  final bool enableKeyboardNavigation;

  final ViewMouseFocusPolicy mouseFocusPolicy;

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
  });
}

class _InternalViewConfig extends ViewConfig {
  const _InternalViewConfig()
      : super(
    quickSuggestionMode: QuickSuggestionMode.none,
    enableKeyboardNavigation: false,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
  );
}
