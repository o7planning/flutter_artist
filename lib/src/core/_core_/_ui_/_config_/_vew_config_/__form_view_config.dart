part of '../../../core.dart';

abstract class FormViewConfig extends ViewConfig {
  bool get circularFocusTraversal => false;

  const FormViewConfig({
    required super.quickSuggestionMode,
  }) : super(
    enableKeyboardNavigation: false,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
  );
}

class InternalFormViewConfig extends FormViewConfig {
  const InternalFormViewConfig({
    super.quickSuggestionMode = QuickSuggestionMode.none,
  });
}
