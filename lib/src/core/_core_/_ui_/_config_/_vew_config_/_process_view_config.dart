part of '../../../core.dart';

class ProzessViewConfig {
  final QuickSuggestionMode quickSuggestionMode;
  final ProzessViewContext prozessViewContext;

  const ProzessViewConfig({
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.prozessViewContext = ProzessViewContext.initData,
  });
}
