part of '../../../core.dart';

class SrcBlockAndOptions {
  final Block block;
  final QueryType queryType;
  final ListUpdateStrategy? listUpdateStrategy;
  final SuggestedSelection<dynamic>? suggestedSelection;
  final BlockAfterQueryDirective? afterQueryDirective;
  final Pageable? pageable;

  SrcBlockAndOptions({
    required this.block,
    required this.queryType,
    required this.listUpdateStrategy,
    required this.suggestedSelection,
    required this.afterQueryDirective,
    required this.pageable,
  });
}
