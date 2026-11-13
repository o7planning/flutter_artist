part of '../../../core.dart';

class PaginationConfig extends ViewConfig {

  const PaginationConfig() : super(
    enableKeyboardNavigation: false,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
    quickSuggestionMode: QuickSuggestionMode.none,
  );
}
