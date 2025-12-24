part of '../core.dart';

class _ProcessedQueryResult<
    ID extends Object, //
    ITEM extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> {
  final Object? parentBlockCurrentItemId;
  final FILTER_CRITERIA? usedFilterCriteria;
  final Pageable? usedPageable;

  //
  final PageData<ITEM>? queriedPageData;
  final ActionResultState queryResultState;
  final DataState newBlockDataState;

  //
  final List<ITEM> validItems;
  final List<ITEM> invalidItems;
  final List<ITEM> errorItems;

  final ErrorInfo? errorInfo;

  _ProcessedQueryResult({
    required this.parentBlockCurrentItemId,
    required this.usedFilterCriteria,
    required this.usedPageable,
    //
    required this.queriedPageData,
    required this.queryResultState,
    required this.newBlockDataState,
    required this.validItems,
    required this.invalidItems,
    required this.errorItems,
    required this.errorInfo,
  }) {}
}
