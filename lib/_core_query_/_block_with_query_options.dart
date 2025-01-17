part of '../flutter_artist.dart';

class _BlockWithQueryOptions {
  final Block block;
  final ListBehavior listBehavior;
  final SuggestedSelection? suggestedSelection;
  final PostQueryBehavior postQueryBehavior;
  final PageableData? pageable;

  _BlockWithQueryOptions({
    required this.block,
    required this.pageable,
    required this.listBehavior,
    required this.suggestedSelection,
    required this.postQueryBehavior,
  });
}
