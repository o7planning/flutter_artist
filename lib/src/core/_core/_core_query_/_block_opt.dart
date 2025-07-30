part of '../core.dart';

///
/// Block with Query Options
///
class _BlockOpt {
  final Block block;

  final bool forceQuery;
  final bool forceReloadItem;
  final QueryType queryType;
  final ListBehavior? listBehavior;
  final SuggestedSelection? suggestedSelection;
  final PostQueryBehavior? postQueryBehavior;
  final PageableData? pageable;

  _BlockOpt({
    required this.block,
    required this.forceQuery,
    required this.forceReloadItem,
    this.queryType = QueryType.realQuery,
    required this.pageable,
    required this.listBehavior,
    required this.suggestedSelection,
    required this.postQueryBehavior,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(block)}, forceQuery: $forceQuery)";
  }
}
