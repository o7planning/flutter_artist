part of '../../../core.dart';

class TargetBlockAndOptions {
  final Block block;
  final QueryType queryType;
  final ListUpdateStrategy? listUpdateStrategy;
  final SuggestedSelection<dynamic>? suggestedSelection;
  final BlockAfterQueryDirective? afterQueryDirective;
  final Pageable? pageable;

  TargetBlockAndOptions({
    required this.block,
    required this.queryType,
    required this.listUpdateStrategy,
    required this.suggestedSelection,
    required this.afterQueryDirective,
    required this.pageable,
  });
}
