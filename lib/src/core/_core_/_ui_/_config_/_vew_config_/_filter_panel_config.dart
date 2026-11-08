part of '../../../core.dart';

class FilterPanelConfig {
  final BlockViewContext? blockViewContext;
  final ScalarViewContext? scalarViewContext;
  final FilterScreenNavigationContext? screenNavigationContext;

  const FilterPanelConfig({
    this.blockViewContext,
    this.scalarViewContext,
    this.screenNavigationContext,
  });
}
