part of '../../../core.dart';

abstract class ViewConfig {
  final QuickSuggestionMode quickSuggestionMode;

  final bool enableKeyboardNavigation;

  final ViewMouseFocusPolicy mouseFocusPolicy;

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
