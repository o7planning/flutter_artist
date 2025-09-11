part of '../../../core.dart';

class SrcBlockAndOptions {
  final Block block;
  final QueryType queryType;
  final ListBehavior? listBehavior;
  final SuggestedSelection<dynamic>? suggestedSelection;
  final PostQueryBehavior? postQueryBehavior;
  final PageableData? pageable;

  SrcBlockAndOptions({
    required this.block,
    required this.queryType,
    required this.listBehavior,
    required this.suggestedSelection,
    required this.postQueryBehavior,
    required this.pageable,
  });
}
