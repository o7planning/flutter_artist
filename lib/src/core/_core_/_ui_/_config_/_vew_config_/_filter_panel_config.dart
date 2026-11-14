part of '../../../core.dart';

class FilterPanelConfig extends ViewConfig {
  final BlockViewContext? blockViewContext;
  final ScalarViewContext? scalarViewContext;
  final FilterScreenNavigationContext? screenNavigationContext;

  @override
  bool get enableRegionFocus => true;

  @override
  bool get allowDescendantFocus => true;

  const FilterPanelConfig({
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockViewContext,
    this.scalarViewContext,
    this.screenNavigationContext,
  }) : super(
    enableKeyboardNavigation: false,
    mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
  );
}
