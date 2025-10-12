part of '../../../core.dart';

class SrcBlockAndOptions {
  final Block block;
  final QueryType queryType;
  final ItemListMode? itemListMode;
  final SuggestedSelection<dynamic>? suggestedSelection;
  final AfterQueryAction? afterQueryAction;
  final PageableData? pageable;

  SrcBlockAndOptions({
    required this.block,
    required this.queryType,
    required this.itemListMode,
    required this.suggestedSelection,
    required this.afterQueryAction,
    required this.pageable,
  });
}
