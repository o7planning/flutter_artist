part of '../../../core.dart';

class StorageSectionViewConfig extends ViewConfig {
  const StorageSectionViewConfig()
      : super(
          quickSuggestionMode: QuickSuggestionMode.none,
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
        );
}
